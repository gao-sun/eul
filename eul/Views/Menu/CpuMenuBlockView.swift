//
//  CpuMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuMenuBlockView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var cpuStore: CpuStore
    @EnvironmentObject var cpuTopStore: CpuTopStore

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("CPU")
                    .menuSection()
                Spacer()
                cpuStore.usage.map {
                    ProgressBarView(percentage: CGFloat($0))
                }
            }
            cpuStore.usageCPU.map { usageCPU in
                Group {
                    SeparatorView()
                    HStack {
                        MiniSectionView(title: "cpu.system", value: String(format: "%.1f%%", usageCPU.system))
                        Spacer()
                        MiniSectionView(title: "cpu.user", value: String(format: "%.1f%%", usageCPU.user))
                        Spacer()
                        MiniSectionView(title: "cpu.nice", value: String(format: "%.1f%%", usageCPU.nice))
                    }
                }
            }
            if preferenceStore.showTopActivities {
                SeparatorView()
                VStack(spacing: 8) {
                    ForEach(cpuTopStore.topProcesses) {
                        ProcessRowView(section: "cpu", process: $0)
                    }
                    if !cpuTopStore.dataAvailable {
                        Spacer()
                        Text("cpu.waiting_status_report".localized())
                            .secondaryDisplayText()
                        Spacer()
                    }
                }
                .frame(width: 311, height: 102) // fix size to avoid jitter in menu view
            }
        }
        .menuBlock()
    }
}
