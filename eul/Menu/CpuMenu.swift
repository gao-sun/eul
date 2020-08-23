//
//  CpuMenu.swift
//  eul
//
//  Created by Gao Sun on 2020/8/23.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI
import Combine

class CpuMenu: EulComponentMenu {
    @ObservedObject var cpuStore = CpuStore.shared
    private var usageCancellable: AnyCancellable?
    private var usageItem = NSMenuItem.forDisplay(with: "Usage: N/A")
    private var idleItem = NSMenuItem.forDisplay(with: "Idle: N/A")
    private var tempCancellable: AnyCancellable?
    private var tempItem = NSMenuItem.forDisplay(with: "Temp: N/A")

    var items: [NSMenuItem] {
        [usageItem, idleItem, tempItem]
    }

    init() {
        usageCancellable = cpuStore.$usageCPU.sink {
            self.usageItem.title = "Usage: \(String(format: "%.1f%%", ($0?.system ?? 0) + ($0?.user ?? 0)))"
            self.idleItem.title = "Idle: \(String(format: "%.1f%%", 100 - ($0?.system ?? 0) - ($0?.user ?? 0)))"
        }

        tempCancellable = cpuStore.$temp.sink {
            self.tempItem.title = "Temp: \($0)"
        }
    }
}
