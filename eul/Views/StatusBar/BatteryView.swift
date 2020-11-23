//
//  BatteryView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct BatteryView: View {
    @EnvironmentObject var batteryStore: BatteryStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore

    var config: EulComponentConfig {
        componentConfigStore[.Battery]
    }

    var texts: [String] {
        [batteryStore.charge.percentageString]
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                BatteryIconView(
                    isCharging: batteryStore.io.isCharging,
                    charge: batteryStore.charge,
                    acPowered: batteryStore.acPowered
                )
            }
            StatusBarTextView(texts: texts)
                .stableWidth()
        }
    }
}
