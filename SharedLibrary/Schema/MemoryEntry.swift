//
//  MemoryEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct MemoryEntry: SharedWidgetEntry {
    public init(date: Date = Date(), used: Double = 0, total: Double = 0, temp: Double? = nil, isValid: Bool = true) {
        self.date = date
        self.used = used
        self.total = total
        self.temp = temp
        self.isValid = isValid
    }

    public static let containerKey = "MemoryEntry"
    public static let kind = "MemoryWidget"
    public static let sample = MemoryEntry(used: 10, total: 18)

    public var date = Date()
    public var used: Double = 0
    public var total: Double = 0
    public var temp: Double?
    public var isValid: Bool = true

    var usedPercentage: Double {
        used / total * 100
    }

    public var usageString: String {
        isValid ? String(format: "%.0f%%", usedPercentage) : "N/A"
    }
}
