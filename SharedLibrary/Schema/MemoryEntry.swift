//
//  MemoryEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

@available(macOSApplicationExtension 11, *)
public struct MemoryEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, used: Double = 0, total: Double = 0, temp: Double? = nil) {
        self.date = date
        self.outdated = outdated
        self.used = used
        self.total = total
        self.temp = temp
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "MemoryEntry"
    public static let kind = "MemoryWidget"
    public static let sample = MemoryEntry(used: 10, total: 18, temp: 50)

    public var date = Date()
    public var outdated = false
    public var used: Double = 0
    public var total: Double = 0
    public var temp: Double?

    var usedPercentage: Double {
        used / total * 100
    }

    public var usageString: String {
        isValid ? String(format: "%.0f%%", usedPercentage) : "N/A"
    }
}
