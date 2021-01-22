//
//  BluetoothMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import CoreBluetooth
import SwiftUI

struct BluetoothBatteryLevelView: View {
    var initial: Character?
    var batteryLevel: Int

    var body: some View {
        HStack(spacing: 4) {
            if let initial = initial {
                Text(String(initial))
                    .miniSection()
            }
            Text("\(batteryLevel)%")
                .displayText()
        }
    }
}

struct BluetoothRowView: View {
    let device: BluetoothDevice
    var nameWidth: CGFloat = 200

    var body: some View {
        HStack {
            Text(device.displayName)
                .secondaryDisplayText()
                .frame(width: nameWidth, alignment: .leading)
                .lineLimit(1)
            Spacer()
            if let plistDevice = device.plistDevice, device.hasPlistBattery {
                if let batteryPercent = plistDevice.BatteryPercent {
                    BluetoothBatteryLevelView(batteryLevel: Int(batteryPercent * 100))
                }
                if let batteryPercent = plistDevice.BatteryPercentLeft {
                    BluetoothBatteryLevelView(initial: "L", batteryLevel: batteryPercent)
                }
                if let batteryPercent = plistDevice.BatteryPercentRight {
                    BluetoothBatteryLevelView(initial: "R", batteryLevel: batteryPercent)
                }
                if let batteryPercent = plistDevice.BatteryPercentCase {
                    BluetoothBatteryLevelView(initial: "C", batteryLevel: batteryPercent)
                }
            } else if let batteryLevel = device.batteryLevel {
                BluetoothBatteryLevelView(batteryLevel: Int(batteryLevel))
            }
        }
    }
}

struct BluetoothMenuBlockView: View {
    @EnvironmentObject var bluetoothStore: BluetoothStore

    var body: some View {
        VStack(spacing: 8) {
            Text("bluetooth".localized())
                .menuSection()
            if bluetoothStore.devices.count == 0 {
                Text("ui.empty".localized())
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)
            }
            ForEach(bluetoothStore.devices) {
                BluetoothRowView(device: $0)
            }
        }
        .padding(.top, 2)
        .menuBlock()
        .onAppear {
            bluetoothStore.fetch()
        }
    }
}
