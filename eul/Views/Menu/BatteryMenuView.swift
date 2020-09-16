//
//  BatteryMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var batteryStore = BatteryStore.shared
    var io: Info.Battery {
        batteryStore.io
    }

    var body: some View {
        VStack(spacing: 2) {
            Group {
                Text("menu.summary".localized())
                    .menuSection()
                HStack {
                    Text("battery.charge".localized())
                    Spacer()
                    Text(batteryStore.charge.percentageString)
                }
                HStack {
                    Text("battery.power_source".localized())
                    Spacer()
                    Text(io.powerSource.description)
                }
                HStack {
                    Text("battery.is_charging".localized())
                    Spacer()
                    Text("menu.\(io.isCharging ? "yes" : "no")".localized())
                }
                if io.isCharging && io.timeToFullCharge >= 0 {
                    HStack {
                        Text("battery.to_full_charge".localized())
                        Spacer()
                        Text("\(io.timeToFullCharge) min")
                    }
                }
                if !io.isCharging && !io.isCharged && io.timeToEmpty >= 0 {
                    HStack {
                        Text("battery.to_empty".localized())
                        Spacer()
                        Text("\(io.timeToEmpty) min")
                    }
                }
            }
            Group {
                Text("battery.health".localized())
                    .menuSection()
                if batteryStore.maxCapacity > 0 {
                    HStack {
                        Text("battery.max_capacity".localized())
                        Spacer()
                        Text("\(batteryStore.maxCapacity.description) mAh")
                    }
                }
                if batteryStore.designCapacity > 0 {
                    HStack {
                        Text("battery.design_capacity".localized())
                        Spacer()
                        Text("\(batteryStore.designCapacity.description) mAh")
                    }
                }
                HStack {
                    Text("battery.health_percentage".localized())
                    Spacer()
                    Text(batteryStore.health.percentageString)
                }
                HStack {
                    Text("battery.cycle_count".localized())
                    Spacer()
                    Text("\(batteryStore.cycleCount.description)")
                }
                HStack {
                    Text("battery.condition".localized())
                    Spacer()
                    Text(io.condition.description)
                }
            }
        }
        .frame(width: 200)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
