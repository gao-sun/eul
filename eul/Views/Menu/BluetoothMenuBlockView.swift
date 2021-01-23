//
//  BluetoothMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import CoreBluetooth
import SwiftUI

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
                    MenuInfoView(text: "\(Int(batteryPercent * 100))%")
                }
                if let batteryPercent = plistDevice.BatteryPercentLeft {
                    MenuInfoView(label: "L", text: "\(batteryPercent)%")
                }
                if let batteryPercent = plistDevice.BatteryPercentRight {
                    MenuInfoView(label: "R", text: "\(batteryPercent)%")
                }
                if let batteryPercent = plistDevice.BatteryPercentCase {
                    MenuInfoView(label: "C", text: "\(batteryPercent)%")
                }
            } else if let batteryLevel = device.batteryLevel {
                MenuInfoView(text: "\(batteryLevel)%")
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
                    .placeholder()
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
