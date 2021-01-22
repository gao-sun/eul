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
            if let batteryLevel = device.batteryLevel {
                Text("\(batteryLevel)%")
                    .displayText()
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
