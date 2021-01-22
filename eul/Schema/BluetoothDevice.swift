//
//  BluetoothDevice.swift
//  eul
//
//  Created by Gao Sun on 2021/1/22.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import CoreBluetooth
import Foundation
import IOBluetooth

struct BluetoothPlist: Codable {
    struct Cache: Codable {
        var DeviceAddress: String
    }

    struct Device: Codable {
        var BatteryPercentCase: Int?
        var BatteryPercentLeft: Int?
        var BatteryPercentRight: Int?
        var BatteryPercent: Double?
    }

    var LEPairedDevices: [String]?
    var CoreBluetoothCache: [String: Cache]?
    var DeviceCache: [String: Device]?
}

struct BluetoothDevice: Identifiable {
    // https://developer.apple.com/forums/thread/77866
    static let batteryServiceUUID = CBUUID(string: "0x180F")
    static let batteryCharacteristicsUUID = CBUUID(string: "0x2A19")

    let ioDevice: IOBluetoothDevice
    var plistDevice: BluetoothPlist.Device?
    var uuid: UUID?
    var peripheral: CBPeripheral?
    var batteryLevel: UInt8?

    var id: String {
        address
    }

    var address: String {
        ioDevice.addressString
    }

    var displayName: String {
        ioDevice.nameOrAddress
    }

    var hasPlistBattery: Bool {
        plistDevice?.BatteryPercent != nil
            || plistDevice?.BatteryPercentCase != nil
            || plistDevice?.BatteryPercentLeft != nil
            || plistDevice?.BatteryPercentRight != nil
    }

    func copying(
        ioDevice: IOBluetoothDevice? = nil,
        plistDevice: BluetoothPlist.Device? = nil,
        uuid: UUID? = nil,
        peripheral: CBPeripheral? = nil,
        batteryLevel: UInt8? = nil
    ) -> BluetoothDevice {
        BluetoothDevice(
            ioDevice: ioDevice ?? self.ioDevice,
            plistDevice: plistDevice ?? self.plistDevice,
            uuid: uuid ?? self.uuid,
            peripheral: peripheral ?? self.peripheral,
            batteryLevel: batteryLevel ?? self.batteryLevel
        )
    }
}
