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
                    Text(batteryStore.chargeString)
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
                if io.isCharging {
                    HStack {
                        Text("battery.to_full_charge".localized())
                        Spacer()
                        Text("\(io.timeToFullCharge) min")
                    }
                }
                if !io.isCharging && !io.isCharged {
                    HStack {
                        Text("battery.to_empty".localized())
                        Spacer()
                        Text("\(batteryStore.io.timeToEmpty) min")
                    }
                }
            }
            Group {
                Text("battery.health".localized())
                    .menuSection()
                HStack {
                    Text("battery.max_capacity".localized())
                    Spacer()
                    Text("\(batteryStore.maxCapacity.description) mAh")
                }
                HStack {
                    Text("battery.design_capacity".localized())
                    Spacer()
                    Text("\(batteryStore.designCapacity.description) mAh")
                }
                HStack {
                    Text("battery.cycle_count".localized())
                    Spacer()
                    Text("\(batteryStore.cycleCount.description)")
                }
                HStack {
                    Text("battery.condition".localized())
                    Spacer()
                    Text(batteryStore.io.condition.description)
                }
            }
        }
        .frame(width: 200)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
