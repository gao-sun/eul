//
//  GpuView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/24.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI

struct GpuView: View {
    @EnvironmentObject var gpuStore: GpuStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore
    @EnvironmentObject var textStore: ComponentsStore<GpuTextComponent>

    var config: EulComponentConfig {
        componentConfigStore[.GPU]
    }

    var texts: [String] {
        textStore.activeComponents.map {
            switch $0 {
            case .usagePercentage:
                return gpuStore.usageAverageString ?? "N/A"
            case .temperature:
                return gpuStore.temperatureAverage?.temperatureString ?? "N/A"
            }
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("GPU")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if config.showGraph {
                LineChart(points: gpuStore.usageHistory)
            }
            if textStore.showComponents {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }
        }
    }
}
