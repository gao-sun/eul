//
//  BatteryEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct BatteryEntry: SharedWidgetEntry {
    public init(date: Date, isValid: Bool) {
        self.date = date
        self.isValid = isValid
    }

    public init(date: Date = Date(), isCharging: Bool = false, acPowered: Bool = false, charge: Double? = nil, capacity: Int = 0, maxCapacity: Int = 0, designCapacity: Int = 0, cycleCount: Int = 0, conditionString: String = "N/A", isValid: Bool = true) {
        self.date = date
        self.isCharging = isCharging
        self.acPowered = acPowered
        self.charge = charge
        self.capacity = capacity
        self.maxCapacity = maxCapacity
        self.designCapacity = designCapacity
        self.cycleCount = cycleCount
        self.conditionString = conditionString
        self.isValid = isValid
    }

    public static let containerKey = "BatteryEntry"
    public static let kind = "BatteryWidget"
    public static let sample = BatteryEntry(charge: 1, capacity: 100, maxCapacity: 100, designCapacity: 100)

    public var date = Date()
    public var isCharging = false
    public var acPowered = false
    public var charge: Double?
    public var capacity = 0
    public var maxCapacity = 0
    public var designCapacity = 0
    public var cycleCount = 0
    public var conditionString = "N/A"
    public var isValid: Bool = true

    public var chargeString: String {
        guard isValid, let charge = charge else {
            return "N/A"
        }
        return charge.percentageString
    }

    public var health: Double {
        Double(maxCapacity) / Double(designCapacity)
    }
}
