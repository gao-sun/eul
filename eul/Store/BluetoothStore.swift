//
//  BluetoothStore.swift
//  eul
//
//  Created by Gao Sun on 2021/1/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation
import IOBluetooth

struct BluetoothPlist: Codable {
    var LEPairedDevices: [String]
}

struct BluetoothDevice: Identifiable {
    let device: IOBluetoothDevice

    var id: String {
        device.addressString
    }

    var displayName: String {
        device.nameOrAddress
    }

    var batteryLevel: String? {
        nil
    }
}

class BluetoothStore: ObservableObject, Refreshable {
    private let pListDecoder = PropertyListDecoder()
    private var bluetoothPlist: BluetoothPlist?

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

    @objc func refresh() {
        readPlist()

        devices = IOBluetoothDevice.pairedDevices()?.compactMap {
            guard let device = $0 as? IOBluetoothDevice else {
                return nil
            }
            return BluetoothDevice(device: device)
        } ?? []
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
