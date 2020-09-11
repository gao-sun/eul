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
            Text("Summary")
                .menuSection()
            HStack {
                Text("Charge")
                Spacer()
                Text("\(batteryStore.charge)%")
            }
            HStack {
                Text("Power Source")
                Spacer()
                Text(io.powerSource.description)
            }
            if io.isCharging {
                HStack {
                    Text("To Full Charge")
                    Spacer()
                    Text("\(io.timeToFullCharge) min")
                }
            }
            if !io.isCharging && !io.isCharged {
                HStack {
                    Text("To Empty")
                    Spacer()
                    Text("\(batteryStore.io.timeToEmpty) min")
                }
            }
            Text("Health")
                .menuSection()
            HStack {
                Text("Max Capacity")
                Spacer()
                Text("\(batteryStore.maxCapacity.description) mAh")
            }
            HStack {
                Text("Design Capacity")
                Spacer()
                Text("\(batteryStore.designCapacity.description) mAh")
            }
            HStack {
                Text("Cycle Count")
                Spacer()
                Text("\(batteryStore.cycleCount.description)")
            }
            HStack {
                Text("Condition")
                Spacer()
                Text(batteryStore.io.condition.description)
            }
        }
        .frame(width: 200)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}

