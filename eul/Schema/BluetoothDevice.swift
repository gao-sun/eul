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
    struct BluetoothCache: Codable {
        var DeviceAddress: String
    }

    var LEPairedDevices: [String]
    var CoreBluetoothCache: [String: BluetoothCache]
}

struct BluetoothDevice: Identifiable {
    // https://developer.apple.com/forums/thread/77866
    static let batteryServiceUUID = CBUUID(string: "0x180F")
    static let batteryCharacteristicsUUID = CBUUID(string: "0x2A19")

    let device: IOBluetoothDevice
    var uuid: UUID?
    var peripheral: CBPeripheral?
    var batteryLevel: UInt8?

    var id: String {
        address
    }

    var address: String {
        device.addressString
    }

    var displayName: String {
        device.nameOrAddress
    }

    var batteryDescription: String {
        guard let batteryLevel = batteryLevel else {
            return "N/A"
        }
        return "\(batteryLevel)%"
    }

    func withBatteryLevel(_ level: UInt8) -> BluetoothDevice {
        BluetoothDevice(device: device, uuid: uuid, peripheral: peripheral, batteryLevel: level)
    }
}
