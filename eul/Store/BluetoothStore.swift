//
//  BluetoothStore.swift
//  eul
//
//  Created by Gao Sun on 2021/1/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import CoreBluetooth
import Foundation
import IOBluetooth

class BluetoothStore: NSObject, ObservableObject {
    private let pListDecoder = PropertyListDecoder()
    private var cbCenteralManager: CBCentralManager?
    private var bluetoothPlist: BluetoothPlist?
    private var batteryCharacteristicsDict = [UUID: CBCharacteristic]()
    private var batteryLevelDict = [UUID: CBCharacteristic]()

    @Published var devices: [BluetoothDevice] = []

    var connectedDevices: [BluetoothDevice] {
        devices.filter { $0.ioDevice.isConnected() }
    }

    private func readPlist() {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.bluetooth.plist")) else {
            bluetoothPlist = nil
            return
        }

        bluetoothPlist = try? pListDecoder.decode(BluetoothPlist.self, from: data)
    }

    private func getUUID(by address: String) -> UUID? {
        guard let uuidString = bluetoothPlist?.CoreBluetoothCache?.first(where: { $1.DeviceAddress == address })?.key else {
            return nil
        }
        return UUID(uuidString: uuidString)
    }

    private func getPlistDevice(by address: String) -> BluetoothPlist.Device? {
        guard let device = bluetoothPlist?.DeviceCache?.first(where: { $0.key == address })?.value else {
            return nil
        }
        return device
    }

    func fetch() {
        readPlist()

        let connectedDevices: [BluetoothDevice] = IOBluetoothDevice.pairedDevices()?.compactMap {
            guard let ioDevice = $0 as? IOBluetoothDevice, ioDevice.isConnected() else {
                return nil
            }
            return BluetoothDevice(
                ioDevice: ioDevice,
                plistDevice: getPlistDevice(by: ioDevice.addressString),
                uuid: getUUID(by: ioDevice.addressString)
            )
        } ?? []

        Print(
            "🔵🦷 connected devices",
            connectedDevices.map { "name=\($0.ioDevice.name ?? "N/A"), address=\($0.ioDevice.addressString ?? "N/A")" }
        )

        let peripherals = cbCenteralManager?.retrievePeripherals(withIdentifiers: connectedDevices.compactMap { $0.uuid }) ?? []

        devices = connectedDevices
            .map { device in
                device.copying(
                    peripheral: peripherals.first(where: { $0.identifier == device.uuid })
                )
            }

        devices.forEach {
            Print("🔵🦷 fetching peripheral for device", $0.displayName, $0.address)

            guard let peripheral = $0.peripheral else {
                Print("⚠️ peripheral not found")
                return
            }

            if peripheral.state == .disconnected {
                Print("⚠️ peripheral not connected, trying to connect")
                cbCenteralManager?.connect(peripheral, options: nil)
            } else if peripheral.state == .connected {
                Print("🔵🦷 peripheral connected, reading battery characteristics")
                guard let batteryCharacteristics = batteryCharacteristicsDict[peripheral.identifier] else {
                    Print("⚠️ battery characteristics for \($0.displayName) not found")
                    return
                }
                peripheral.readValue(for: batteryCharacteristics)
            }
        }
    }

    override init() {
        super.init()
        cbCenteralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BluetoothStore: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Print("🔵🦷 state update", central.state.rawValue)
    }

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Print("🔵🦷 did connect peripheral", peripheral.description)
        peripheral.delegate = self
        peripheral.discoverServices([BluetoothDevice.batteryServiceUUID])
    }
}

extension BluetoothStore: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        Print("🔵🦷 did discover services", peripheral.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryService = peripheral.services?.first(where: { $0.uuid == BluetoothDevice.batteryServiceUUID }) else {
            Print("❔ battery service not found, skipping")
            return
        }

        peripheral.discoverCharacteristics([BluetoothDevice.batteryCharacteristicsUUID], for: batteryService)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        Print("🔵🦷 did discover characteristics", peripheral.description, service.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryCharacteristics = service.characteristics?.first(where: { $0.uuid == BluetoothDevice.batteryCharacteristicsUUID }) else {
            Print("❔ battery characteristics not found, skipping")
            return
        }

        batteryCharacteristicsDict[peripheral.identifier] = batteryCharacteristics
        peripheral.readValue(for: batteryCharacteristics)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        Print("🔵🦷 did update value for characteristics", peripheral.description, characteristic.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryLevel = characteristic.value?[0] else {
            return
        }

        devices = devices.map { $0.uuid == peripheral.identifier ? $0.copying(batteryLevel: batteryLevel) : $0 }
    }
}
