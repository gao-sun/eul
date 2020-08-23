//
//  CpuStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class CpuStore: ObservableObject, Refreshable {
    static let shared = CpuStore()

    @Published var usage = ""
    @Published var temp = ""
    @Published var usageCPU: (system: Double, user: Double, idle: Double, nice: Double)?

    private func getUsage() {
        usageCPU = Info.system.usageCPU()
        usage = String(format: "%.1f%%", (usageCPU?.system ?? 0) + (usageCPU?.user ?? 0))
    }

    private func getTemp() {
        temp = String(format: "%.1f°C", SmcControl.shared.cpuProximityTemperature)
    }

    @objc func refresh() {
        getUsage()
        getTemp()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
