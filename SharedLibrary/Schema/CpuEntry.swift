//
//  CpuEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct CpuEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, temp: Double? = nil, usageSystem: Double? = nil, usageUser: Double? = nil, usageNice: Double? = nil) {
        self.date = date
        self.outdated = outdated
        self.temp = temp
        self.usageSystem = usageSystem
        self.usageUser = usageUser
        self.usageNice = usageNice
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "CpuEntry"
    public static let kind = "CpuWidget"
    public static let sample = CpuEntry(temp: 50, usageSystem: 10, usageUser: 20, usageNice: 30)

    public var date = Date()
    public var outdated = false
    public var temp: Double?
    public var usageSystem: Double?
    public var usageUser: Double?
    public var usageNice: Double?

    public var usageString: String {
        guard isValid, let usageSystem = usageSystem, let usageUser = usageUser else {
            return "N/A"
        }
        return String(format: "%.0f%%", usageSystem + usageUser)
    }
}
