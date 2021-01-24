//
//  GpuMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/24.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI

struct GpuMenuBlockView: View {
    @EnvironmentObject var gpuStore: GpuStore

    func toGHzString(_ mhz: Int) -> String {
        String(format: "%.1f", Double(mhz) / 1000) + "GHz"
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text("component.gpu".localized())
                    .menuSection()
                Spacer()
                LineChart(points: gpuStore.usageHistory, frame: CGSize(width: 35, height: 20))
            }
            ForEach(gpuStore.gpus) { gpu in
                HStack {
                    Text(gpu.model ?? "N/A")
                        .secondaryDisplayText()
                        .lineLimit(1)
                    Spacer()
                    if let statistic = gpuStore.getStatustic(for: gpu) {
                        if let coreClock = statistic.coreClock {
                            MenuInfoView(label: "core", text: toGHzString(coreClock))
                        }
                        if let memoryClock = statistic.memoryClock {
                            MenuInfoView(label: "mem", text: toGHzString(memoryClock))
                        }
                        if let temperature = statistic.temperature {
                            MenuInfoView(text: temperature.temperatureString)
                        }
                        MenuInfoView(text: "\(statistic.usagePercentage)%")
                    } else {
                        MenuInfoView(text: "N/A")
                    }
                }
            }
        }
        .padding(.top, 2)
        .menuBlock()
    }
}
