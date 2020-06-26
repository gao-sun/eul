//
//  CPUStatus.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct CPUStatus: StatusItem {
    private let cpuUsage = CpuUsage()

    var title: String {
        "\(usage) \(temp)"
    }
    var temp: String {
        String(format: "%.1f°C", SMCObjC.calculateTemp())
    }
    var usage: String {
        String(format: "%.1f%%", cpuUsage.getUsage() * 100)
    }
}
