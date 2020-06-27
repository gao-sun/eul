//
//  CpuStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class CpuStore: ObservableObject {
    static let shared = CpuStore()

    @Published var usage = ""
    @Published var temp = ""
    @Published var fans: [Fan] = []

    private func getUsage() {
        let cpu = Info.system.usageCPU()
        usage = String(format: "%.1f%%", cpu.system + cpu.user)
    }

    private func getTemp() {
        SmcControl.shared.refresh()
        temp = String(format: "%.1f°C", SmcControl.shared.cpuProximityTemperature)
    }

    func getRepeatedly() {
        getUsage()
        getTemp()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.getRepeatedly()
        }
    }

    init() {
        getRepeatedly()
    }
}
