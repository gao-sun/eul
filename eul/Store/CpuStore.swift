//
//  CpuStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SystemKit
import WidgetKit

class CpuStore: ObservableObject, Refreshable {
    static let shared = CpuStore()

    @Published var usageString = ""
    @Published var temp: Double?
    @Published var gpuTemp: Double?
    @Published var usageCPU: (system: Double, user: Double, idle: Double, nice: Double)?
    @Published var physicalCores = 0
    @Published var logicalCores = 0
    @Published var upTime: (days: Int, hrs: Int, mins: Int, secs: Int)?
    @Published var thermalLevel: System.ThermalLevel = .Unknown
    @Published var usageHistory: [Double] = []

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
        let usage = Info.system.usageCPU()
        usageCPU = usage
        usageString = String(format: "%.0f%%", usage.system + usage.user)
        usageHistory = (usageHistory + [usage.system + usage.user]).suffix(LineChart.defaultMaxPointCount)
    }

    private func getTemp() {
        temp = SmcControl.shared.cpuProximityTemperature
        gpuTemp = SmcControl.shared.gpuProximityTemperature
    }

    @objc func refresh() {
        getInfo()
        getUsage()
        getTemp()
        writeToContainer()
    }

    func writeToContainer() {
        Container.set(CpuEntry(
            temp: temp,
            usageSystem: usageCPU?.system,
            usageUser: usageCPU?.user,
            usageNice: usageCPU?.nice
        ))
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: CpuEntry.kind)
        }
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
