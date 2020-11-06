//
//  CpuStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import SystemKit
import WidgetKit

class CpuStore: ObservableObject, Refreshable {
    static let shared = CpuStore()

    private var cancellable: AnyCancellable?

    @Published var usageString = ""
    @Published var temp: Double?
    @Published var gpuTemp: Double?
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

    private func getTemp() {
        temp = SmcControl.shared.cpuProximityTemperature
        gpuTemp = SmcControl.shared.gpuProximityTemperature
    }

    @objc func refresh() {
        getInfo()
        getUsage()
        getTemp()
    }

    func writeToContainer() {
        Container.set(CpuEntry(
            temp: temp,
            usageSystem: usageCPU?.system,
            usageUser: usageCPU?.user,
            usageNice: usageCPU?.nice
        ))
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "CpuWidget")
        }
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
        cancellable = objectWillChange.sink {
            DispatchQueue.main.async {
                self.writeToContainer()
            }
        }
    }
}
