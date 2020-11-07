//
//  CpuInfo.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct CpuEntry: SharedWidgetEntry {
    static let containerKey = "CpuEntry"
    static let kind = "CpuWidget"
    static let sample = CpuEntry(temp: 50, usageSystem: 10, usageUser: 20, usageNice: 30)

    var date = Date()
    var temp: Double? = nil
    var usageSystem: Double? = nil
    var usageUser: Double? = nil
    var usageNice: Double? = nil
    var isValid: Bool = true

    var usageString: String {
        guard let usageSystem = usageSystem, let usageUser = usageUser else {
            return "N/A"
        }
        return String(format: "%.0f%%", usageSystem + usageUser)
    }
}
