//
//  CpuView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuView: View {
    @EnvironmentObject var cpuStore: CpuStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore
    @EnvironmentObject var textStore: ComponentsStore<CpuTextComponent>

    var config: EulComponentConfig {
        componentConfigStore[.CPU]
    }

    var texts: [String] {
        textStore.activeComponents.map {
            switch $0 {
            case .usagePercentage:
                return cpuStore.usageString
            case .temperature:
                return cpuStore.temp.map { SmcControl.shared.formatTemp($0) } ?? "N/A"
            }
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("CPU")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if config.showGraph {
                LineChart(points: cpuStore.usageHistory)
            }
            if textStore.showComponents {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }
        }
    }
}
