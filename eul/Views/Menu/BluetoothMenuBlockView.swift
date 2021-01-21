//
//  BluetoothMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import CoreBluetooth
import SwiftUI

struct BluetoothMenuBlockView: View {
    @EnvironmentObject var bluetoothStore: BluetoothStore

    var body: some View {
        HStack(spacing: 4) {
            Text("bluetooth".localized())
                .menuSection()
            Spacer()
            HStack {
                ForEach(bluetoothStore.devices) { item in
                    MiniSectionView(
                        title: item.device.nameOrAddress,
                        value: "100"
                    )
                    .frame(width: 80)
                }
            }
        }
        .padding(.top, 2)
        .menuBlock()
    }
}
