//
//  BatteryMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
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
                    Text(io.timeToFullCharge.readableTimeInMin)
                        .displayText()
                    Text("battery.to_full_charge".localized())
                        .miniSection()
                        .padding(.trailing, 4)
                }
                if !io.isCharging && !io.isCharged && io.timeToEmpty >= 0 {
                    Text(io.timeToEmpty.readableTimeInMin)
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
                Text("battery.health".localized())
                    .miniSection()
                Text(batteryStore.health.percentageString)
                    .displayText()
                if batteryStore.maxCapacity > 0 {
                    Spacer()
                    Text("battery.max_capacity".localized())
                        .miniSection()
                    Text("\(batteryStore.maxCapacity.description) mAh")
                        .displayText()
                }
                if batteryStore.designCapacity > 0 {
                    Spacer()
                    Text("battery.design_capacity".localized())
                        .miniSection()
                    Text("\(batteryStore.designCapacity.description) mAh")
                        .displayText()
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
                Spacer()
                MiniSectionView(title: "battery.time".localized(), value: batteryStore.timeRemaining)
            }
        }
        .menuBlock()
    }
}
