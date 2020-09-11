//
//  MemoryStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/29.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SystemKit

class MemoryStore: ObservableObject, Refreshable {
    static let shared = MemoryStore()

    static func memoryUnit(_ value: Double) -> String {
        value < 1.0 ? String(Int(value * 1000.0)) + " MB" : String(format: "%.2f", value) + " GB"
    }

    @Published var free: Double = 0
    @Published var active: Double = 0
    @Published var inactive: Double = 0
    @Published var wired: Double = 0
    @Published var compressed: Double = 0
    @Published var appMemory: Double = 0
    @Published var cachedFiles: Double = 0
    @Published var temp: Double?

    var used: Double {
        appMemory + wired + compressed
    }

    var total: Double {
        free + inactive + active + wired + compressed
    }

    var freeString: String {
        MemoryStore.memoryUnit(total - used)
    }
    var usedString: String {
        MemoryStore.memoryUnit(used)
    }

    @objc func refresh() {
        (free, active, inactive, wired, compressed, appMemory, cachedFiles) = System.memoryUsage()
        temp = SmcControl.shared.memoryProximityTemperature
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
