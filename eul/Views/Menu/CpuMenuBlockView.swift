//
//  CpuMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuMenuBlockView: View {
    struct UsageDetailSectionView: View {
        var title: String
        var usage: Double

        var body: some View {
            VStack(alignment: .leading, spacing: 2) {
                Text(title.localized())
                    .miniSection()
                Text(String(format: "%.1f%%", usage))
                    .displayText()
            }
        }
    }

    @EnvironmentObject var cpuStore: CpuStore

    var body: some View {
        VStack(spacing: 4) {
            Text("CPU")
                .menuSection()
            cpuStore.usage.map {
                ProgressBarView(percentage: CGFloat($0))
            }
            cpuStore.usageCPU.map { usageCPU in
                Group {
                    SeparatorView()
                    HStack {
                        UsageDetailSectionView(title: "cpu.system", usage: usageCPU.system)
                        Spacer()
                        UsageDetailSectionView(title: "cpu.user", usage: usageCPU.user)
                        Spacer()
                        UsageDetailSectionView(title: "cpu.nice", usage: usageCPU.nice)
                    }
                }
            }
            if cpuStore.temp != nil || cpuStore.gpuTemp != nil {
                SeparatorView()
            }
            cpuStore.temp.map { temp in
                HStack {
                    Text("cpu.temperature".localized())
                        .miniSection()
                    Spacer()
                    Text(SmcControl.shared.formatTemp(temp))
                        .displayText()
                }
            }
            cpuStore.gpuTemp.map { temp in
                HStack {
                    Text("gpu.temperature".localized())
                        .miniSection()
                    Spacer()
                    Text(SmcControl.shared.formatTemp(temp))
                        .displayText()
                }
            }
        }
        .menuBlock()
    }
}
