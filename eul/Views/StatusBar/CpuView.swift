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
                return cpuStore.temp?.temperatureString ?? "N/A"
            case .loadAverage1Min:
                return cpuStore.loadAverage1MinString
            case .loadAverage5Min:
                return cpuStore.loadAverage5MinString
            case .loadAverage15Min:
                return cpuStore.loadAverage15MinString
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
