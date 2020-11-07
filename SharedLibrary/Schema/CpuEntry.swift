//
//  CpuEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct CpuEntry: SharedWidgetEntry {
    public init(date: Date, isValid: Bool) {
        self.date = date
        self.isValid = isValid
    }

    public init(date: Date = Date(), temp: Double? = nil, usageSystem: Double? = nil, usageUser: Double? = nil, usageNice: Double? = nil, isValid: Bool = true) {
        self.date = date
        self.temp = temp
        self.usageSystem = usageSystem
        self.usageUser = usageUser
        self.usageNice = usageNice
        self.isValid = isValid
    }

    public static let containerKey = "CpuEntry"
    public static let kind = "CpuWidget"
    public static let sample = CpuEntry(temp: 50, usageSystem: 10, usageUser: 20, usageNice: 30)

    public var date = Date()
    public var temp: Double?
    public var usageSystem: Double?
    public var usageUser: Double?
    public var usageNice: Double?
    public var isValid: Bool = true

    public var usageString: String {
        guard isValid, let usageSystem = usageSystem, let usageUser = usageUser else {
            return "N/A"
        }
        return String(format: "%.0f%%", usageSystem + usageUser)
    }
}
