//
//  CpuMenu.swift
//  eul
//
//  Created by Gao Sun on 2020/8/23.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var cpuStore = CpuStore.shared

    var usage: Double {
        guard let usageCPU = cpuStore.usageCPU else {
            return 0
        }
        return usageCPU.system + usageCPU.user
    }

    var body: some View {
        VStack(spacing: 2) {
            Group {
                Text("Summary")
                    .menuSection()
                HStack {
                    Text("Usage")
                    Spacer()
                    Text(String(format: "%.1f%%", usage))
                }
                HStack {
                    Text("Idle")
                    Spacer()
                    Text(String(format: "%.1f%%", 100 - usage))
                }
                cpuStore.temp.map { temp in
                    HStack {
                        Text("Temp")
                        Spacer()
                        Text(SmcControl.shared.formatTemp(temp))
                    }
                }
                cpuStore.gpuTemp.map { temp in
                    HStack {
                        Text("GPU Temp")
                        Spacer()
                        Text(SmcControl.shared.formatTemp(temp))
                    }
                }
            }
            Group {
                Text("Info")
                    .menuSection()
                HStack {
                    Text("Physical Cores")
                    Spacer()
                    Text(cpuStore.physicalCores.description)
                }
                HStack {
                    Text("Logical Cores")
                    Spacer()
                    Text(cpuStore.logicalCores.description)
                }
                cpuStore.upTime.map { upTime in
                    HStack {
                        Text("Up Time")
                        Spacer()
                        Text("\(upTime.days)d \(upTime.hrs)h \(upTime.mins)m")
                    }
                }
                if cpuStore.thermalLevel != .NotPublished && cpuStore.thermalLevel != .Unknown {
                    HStack {
                        Text("Thermal Lv.")
                        Spacer()
                        Text(cpuStore.thermalLevel.rawValue.titleCase())
                            .font(.system(size: 12, weight: .regular))
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .frame(width: 160)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
