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
                Text("menu.summary".localized())
                    .menuSection()
                HStack {
                    Text("cpu.usage".localized())
                    Spacer()
                    Text(String(format: "%.1f%%", usage))
                }
                HStack {
                    Text("cpu.idle".localized())
                    Spacer()
                    Text(String(format: "%.1f%%", 100 - usage))
                }
                cpuStore.temp.map { temp in
                    HStack {
                        Text("cpu.temperature".localized())
                        Spacer()
                        Text(SmcControl.shared.formatTemp(temp))
                    }
                }
                cpuStore.gpuTemp.map { temp in
                    HStack {
                        Text("gpu.temperature".localized())
                        Spacer()
                        Text(SmcControl.shared.formatTemp(temp))
                    }
                }
            }
            Group {
                Text("cpu.info".localized())
                    .menuSection()
                HStack {
                    Text("cpu.physical_cores".localized())
                    Spacer()
                    Text(cpuStore.physicalCores.description)
                }
                HStack {
                    Text("cpu.logical_cores".localized())
                    Spacer()
                    Text(cpuStore.logicalCores.description)
                }
                cpuStore.upTime.map { upTime in
                    HStack {
                        Text("cpu.up_time".localized())
                        Spacer()
                        Text("\(upTime.days)d \(upTime.hrs)h \(upTime.mins)m")
                    }
                }
                if cpuStore.thermalLevel != .NotPublished && cpuStore.thermalLevel != .Unknown {
                    HStack {
                        Text("cpu.thermal_level".localized())
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
