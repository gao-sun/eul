//
//  CpuMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuMenuBlockView: View {
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
                        MiniSectionView(title: "cpu.system", value: String(format: "%.1f%%", usageCPU.system))
                        Spacer()
                        MiniSectionView(title: "cpu.user", value: String(format: "%.1f%%", usageCPU.user))
                        Spacer()
                        MiniSectionView(title: "cpu.nice", value: String(format: "%.1f%%", usageCPU.nice))
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
