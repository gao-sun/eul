//
//  MemoryView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/29.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct MemoryView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore
    @EnvironmentObject var textStore: ComponentsStore<MemoryTextComponent>

    var config: EulComponentConfig {
        componentConfigStore[.Memory]
    }

    var texts: [String] {
        textStore.activeComponents.map {
            switch $0 {
            case .free:
                return memoryStore.freeString
            case .usage:
                return memoryStore.usedString
            case .total:
                return memoryStore.total.memoryString
            case .usagePercentage:
                return memoryStore.usedPercentageString
            case .temperature:
                return memoryStore.temp?.temperatureString ?? "N/A"
            }
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Memory")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if config.showGraph {
                LineChart(points: memoryStore.usageHistory)
            }
            if textStore.showComponents {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }
        }
    }
}
