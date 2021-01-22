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
        devices.filter { $0.device.isConnected() }
    }

    private func readPlist() {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: "/Library/Preferences/com.apple.bluetooth.plist")) else {
            bluetoothPlist = nil
            return
        }

        bluetoothPlist = try? pListDecoder.decode(BluetoothPlist.self, from: data)
    }

    private func getUUID(by address: String) -> UUID? {
        guard let uuidString = bluetoothPlist?.CoreBluetoothCache.first(where: { $1.DeviceAddress == address })?.key else {
            return nil
        }
        return UUID(uuidString: uuidString)
    }

    func fetch() {
        readPlist()

        let connectedDevices: [BluetoothDevice] = IOBluetoothDevice.pairedDevices()?.compactMap {
            guard let device = $0 as? IOBluetoothDevice, device.isConnected() else {
                return nil
            }
            return BluetoothDevice(device: device, uuid: getUUID(by: device.addressString))
        } ?? []

        let peripherals = cbCenteralManager?.retrievePeripherals(withIdentifiers: connectedDevices.compactMap { $0.uuid }) ?? []

        devices = connectedDevices
            .map { device in
                BluetoothDevice(
                    device: device.device,
                    uuid: device.uuid,
                    peripheral: peripherals.first(where: { $0.identifier == device.uuid })
                )
            }

        // TO-DO: display battery level of Apple peripherals
        devices.forEach {
            if let peripheral = $0.peripheral {
                if peripheral.state == .disconnected {
                    cbCenteralManager?.connect(peripheral, options: nil)
                } else if peripheral.state == .connected {
                    if let batteryCharacteristics = batteryCharacteristicsDict[peripheral.identifier] {
                        peripheral.readValue(for: batteryCharacteristics)
                    }
                }
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
        print("🔵🦷 state update", central.state.rawValue)
    }

    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("🔵🦷 did connect peripheral", peripheral.description)
        peripheral.delegate = self
        peripheral.discoverServices([BluetoothDevice.batteryServiceUUID])
    }
}

extension BluetoothStore: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("🔵🦷 did discover services", peripheral.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryService = peripheral.services?.first(where: { $0.uuid == BluetoothDevice.batteryServiceUUID }) else {
            print("❔ battery service not found, skipping")
            return
        }

        peripheral.discoverCharacteristics([BluetoothDevice.batteryCharacteristicsUUID], for: batteryService)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("🔵🦷 did discover characteristics", peripheral.description, service.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryCharacteristics = service.characteristics?.first(where: { $0.uuid == BluetoothDevice.batteryCharacteristicsUUID }) else {
            print("❔ battery characteristics not found, skipping")
            return
        }

        batteryCharacteristicsDict[peripheral.identifier] = batteryCharacteristics
        peripheral.readValue(for: batteryCharacteristics)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("🔵🦷 did update value for characteristics", peripheral.description, characteristic.description)

        if let error = error {
            print("⚠️ error", error)
            return
        }

        guard let batteryLevel = characteristic.value?[0] else {
            return
        }

        devices = devices.map { $0.uuid == peripheral.identifier ? $0.withBatteryLevel(batteryLevel) : $0 }
    }
}
