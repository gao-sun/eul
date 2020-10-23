//
//  CpuStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SystemKit

class CpuStore: ObservableObject, Refreshable {
    static let shared = CpuStore()

    @Published var usageString = ""
    @Published var usageCPU: (system: Double, user: Double, idle: Double, nice: Double)?
    @Published var physicalCores = 0
    @Published var logicalCores = 0
    @Published var upTime: (days: Int, hrs: Int, mins: Int, secs: Int)?
    @Published var thermalLevel: System.ThermalLevel = .Unknown

    var usage: Double? {
        guard let usageCPU = usageCPU else {
            return nil
        }
        return usageCPU.system + usageCPU.user
    }

    private func getInfo() {
        physicalCores = System.physicalCores()
        logicalCores = System.logicalCores()
        upTime = System.uptime()
        thermalLevel = System.thermalLevel()
    }

    private func getUsage() {
        usageCPU = Info.system.usageCPU()
        usageString = String(format: "%.1f%%", (usageCPU?.system ?? 0) + (usageCPU?.user ?? 0))
    }

    @objc func refresh() {
        getInfo()
        getUsage()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
