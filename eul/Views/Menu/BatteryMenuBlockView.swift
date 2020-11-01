//
//  BatteryMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryMenuBlockView: View {
    @EnvironmentObject var batteryStore: BatteryStore
    var io: Info.Battery {
        batteryStore.io
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("battery".localized())
                    .menuSection()
                Spacer()
                if io.isCharging && io.timeToFullCharge >= 0 {
                    Text("\(io.timeToFullCharge) min")
                        .displayText()
                    Text("battery.to_full_charge".localized())
                        .miniSection()
                        .padding(.trailing, 4)
                }
                if !io.isCharging && !io.isCharged && io.timeToEmpty >= 0 {
                    Text("\(io.timeToEmpty) min")
                        .displayText()
                    Text("battery.to_empty".localized())
                        .miniSection()
                        .padding(.trailing, 4)
                }
                BatteryIconView(
                    size: 15,
                    isCharging: batteryStore.io.isCharging,
                    charge: batteryStore.charge,
                    acPowered: batteryStore.acPowered
                )
                Text(batteryStore.charge.percentageString)
                    .displayText()
            }
            HStack {
                Text(batteryStore.health.percentageString)
                    .displayText()
                Text("battery.health".localized())
                    .miniSection()
                if batteryStore.maxCapacity > 0 {
                    Spacer()
                    Text("\(batteryStore.maxCapacity.description) mAh")
                        .displayText()
                    Text("battery.max_capacity".localized())
                        .miniSection()
                }
                if batteryStore.designCapacity > 0 {
                    Spacer()
                    Text("\(batteryStore.designCapacity.description) mAh")
                        .displayText()
                    Text("battery.design_capacity".localized())
                        .miniSection()
                }
            }
            .padding(.top, 4)
            SeparatorView()
            HStack {
                MiniSectionView(title: "battery.power_source".localized(), value: io.powerSource.description)
                Spacer()
                MiniSectionView(
                    title: "battery.is_charging".localized(),
                    value: "menu.\(io.isCharging ? "yes" : "no")".localized()
                )
                Spacer()
                MiniSectionView(title: "battery.cycle_count".localized(), value: batteryStore.cycleCount.description)
                Spacer()
                MiniSectionView(title: "battery.condition".localized(), value: io.condition.description)
            }
        }
        .menuBlock()
    }
}
