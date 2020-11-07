//
//  MemoryStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/29.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SystemKit
import WidgetKit

class MemoryStore: ObservableObject, Refreshable {
    static let shared = MemoryStore()

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

    var usedPercentage: Double {
        used / total * 100
    }

    var total: Double {
        free + inactive + active + wired + compressed
    }

    var allFree: Double {
        total - used
    }

    var allFreePercentage: Double {
        allFree / total * 100
    }

    var freeString: String {
        (total - used).memoryString
    }

    var usedString: String {
        used.memoryString
    }

    @objc func refresh() {
        (free, active, inactive, wired, compressed, appMemory, cachedFiles) = System.memoryUsage()
        temp = SmcControl.shared.memoryProximityTemperature
        writeToContainer()
    }

    func writeToContainer() {
        Container.set(MemoryEntry(used: used, total: total, temp: temp))
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: MemoryEntry.kind)
        }
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
