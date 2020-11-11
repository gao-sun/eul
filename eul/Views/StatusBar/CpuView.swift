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
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore

    var config: EulComponentConfig {
        componentConfigStore.configDict[.CPU] ?? EulComponentConfig(component: .CPU)
    }

    var texts: [String] {
        [cpuStore.usageString, cpuStore.temp.map { SmcControl.shared.formatTemp($0) }].compactMap { $0 }
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("CPU")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if config.showText {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }

            if config.showGraph {
                LineChart(points: cpuStore.usageHistory)
            }
        }
    }
}
