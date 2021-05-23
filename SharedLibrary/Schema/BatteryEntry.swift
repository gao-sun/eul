//
//  BatteryEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

@available(macOSApplicationExtension 11, *)
public struct BatteryEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, isCharging: Bool = false, acPowered: Bool = false, charge: Double? = nil, capacity: Int = 0, maxCapacity: Int = 0, designCapacity: Int = 0, cycleCount: Int = 0, condition: BatteryEntry.BatteryCondition = BatteryCondition.good) {
        self.date = date
        self.outdated = outdated
        self.isCharging = isCharging
        self.acPowered = acPowered
        self.charge = charge
        self.capacity = capacity
        self.maxCapacity = maxCapacity
        self.designCapacity = designCapacity
        self.cycleCount = cycleCount
        self.condition = condition
    }

    public enum BatteryCondition: String, Codable {
        case good
        case fair
        case poor
    }

    public enum PowerSourceState: String, Codable {
        case battery
        case acPower
        case unknown
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "BatteryEntry"
    public static let kind = "BatteryWidget"
    public static let sample = BatteryEntry(charge: 1, capacity: 100, maxCapacity: 100, designCapacity: 100)

    public var date = Date()
    public var outdated = false
    public var isCharging = false
    public var acPowered = false
    public var charge: Double?
    public var capacity = 0
    public var maxCapacity = 0
    public var designCapacity = 0
    public var cycleCount = 0
    public var condition = BatteryCondition.good

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
