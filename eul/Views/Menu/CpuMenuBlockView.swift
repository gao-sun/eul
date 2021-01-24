//
//  CpuMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct CpuMenuBlockView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var cpuStore: CpuStore
    @EnvironmentObject var cpuTopStore: TopStore

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("component.cpu".localized())
                    .menuSection()
                Spacer()
                if preferenceStore.cpuMenuDisplay == .usagePercentage {
                    Text(cpuStore.usageString)
                        .displayText()
                }
                LineChart(points: cpuStore.usageHistory, frame: CGSize(width: 35, height: 20))
            }
            cpuStore.usageCPU.map { usageCPU in
                Group {
                    SeparatorView()
                    HStack {
                        if preferenceStore.cpuMenuDisplay == .usagePercentage {
                            MiniSectionView(title: "cpu.system", value: String(format: "%.1f%%", usageCPU.system))
                            Spacer()
                            MiniSectionView(title: "cpu.user", value: String(format: "%.1f%%", usageCPU.user))
                            Spacer()
                            MiniSectionView(title: "cpu.nice", value: String(format: "%.1f%%", usageCPU.nice))
                        }
                        if preferenceStore.cpuMenuDisplay == .loadAverage {
                            MiniSectionView(title: "1 min", value: cpuStore.loadAverage1MinString)
                            Spacer()
                            MiniSectionView(title: "5 min", value: cpuStore.loadAverage5MinString)
                            Spacer()
                            MiniSectionView(title: "15 min", value: cpuStore.loadAverage15MinString)
                        }
                        cpuStore.temp.map { temp in
                            Group {
                                Spacer()
                                MiniSectionView(title: "cpu.temperature", value: SmcControl.shared.formatTemp(temp))
                            }
                        }
                    }
                }
            }
            if preferenceStore.showCPUTopActivities {
                SeparatorView()
                VStack(spacing: 8) {
                    ForEach(cpuTopStore.cpuTopProcesses) {
                        ProcessRowView(section: "cpu", process: $0)
                    }
                    if !cpuTopStore.cpuDataAvailable {
                        Spacer()
                        Text("cpu.waiting_status_report".localized())
                            .secondaryDisplayText()
                        Spacer()
                    }
                }
                .frame(minWidth: 311)
                .frame(height: 102) // fix size to avoid jitter in menu view
            }
        }
        .menuBlock()
    }
}
