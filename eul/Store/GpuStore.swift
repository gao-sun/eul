//
//  GpuStore.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import SwiftUI

class GpuStore: ObservableObject, Refreshable {
    private var activeCancellable: AnyCancellable?

    @ObservedObject var componentsStore = SharedStore.components
    @ObservedObject var menuComponentsStore = SharedStore.menuComponents

    @Published var gpus = [GPU]()
    @Published var gpuStatistics = [GPU.Statistic]()
    @Published var usageHistory: [Double] = []

    var usageAverage: Double? {
        let stats = gpus.compactMap { getStatustic(for: $0) }
        guard stats.count > 0 else {
            return nil
        }
        return Double(stats.reduce(0) { $0 + $1.usagePercentage }) / Double(stats.count)
    }

    var usageAverageString: String? {
        guard let average = usageAverage else {
            return nil
        }
        return "\(String(format: "%.0f", average))%"
    }

    var temperatureAverage: Double? {
        let temps = gpus.compactMap { getStatustic(for: $0)?.temperature }
        guard temps.count > 0 else {
            return nil
        }
        return temps.reduce(0) { $0 + $1 } / Double(temps.count)
    }

    func getStatustic(for gpu: GPU) -> GPU.Statistic? {
        gpuStatistics.first {
            $0.pciMatch.lowercased().contains(gpu.deviceId.deletingPrefix("0x"))
        }
    }

    init() {
        gpus = GPU.getGPUs() ?? []
        initObserver(for: .StoreShouldRefresh)
        // refresh immediately to prevent "N/A"
        activeCancellable = Publishers
            .CombineLatest(componentsStore.$activeComponents, menuComponentsStore.$activeComponents)
            .sink { _ in
                DispatchQueue.main.async {
                    self.refresh()
                }
            }
    }

    @objc func refresh() {
        guard
            componentsStore.activeComponents.contains(.GPU)
            || menuComponentsStore.activeComponents.contains(.GPU)
        else {
            usageHistory = []
            return
        }

        gpuStatistics = GPU.getInfo() ?? []
        usageHistory = (usageHistory + [usageAverage ?? 0]).suffix(LineChart.defaultMaxPointCount)
    }
}
