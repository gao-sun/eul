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

    @Published var usage = ""
    @Published var temp: Double?
    @Published var gpuTemp: Double?
    @Published var usageCPU: (system: Double, user: Double, idle: Double, nice: Double)?
    @Published var physicalCores = 0
    @Published var logicalCores = 0
    @Published var upTime: (days: Int, hrs: Int, mins: Int, secs: Int)?
    @Published var thermalLevel: System.ThermalLevel = .Unknown

    private func getInfo() {
        physicalCores = System.physicalCores()
        logicalCores = System.logicalCores()
        upTime = System.uptime()
        thermalLevel = System.thermalLevel()
    }

    private func getUsage() {
        usageCPU = Info.system.usageCPU()
        usage = String(format: "%.1f%%", (usageCPU?.system ?? 0) + (usageCPU?.user ?? 0))
    }

    private func getTemp() {
        temp = SmcControl.shared.cpuProximityTemperature
        gpuTemp = SmcControl.shared.gpuProximityTemperature
    }

    @objc func refresh() {
        getInfo()
        getUsage()
        getTemp()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
