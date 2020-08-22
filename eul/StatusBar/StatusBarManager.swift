//
//  StatusBarManager.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class StatusBarManager {
    let cpu = StatusBarItem { CpuView(onSizeChange: $0) }
    let fan = StatusBarItem { FanView(onSizeChange: $0) }
    let memory = StatusBarItem { MemoryView(onSizeChange: $0) }
    let battery = StatusBarItem { BatteryView(onSizeChange: $0) }
    let Network = StatusBarItem { NetworkView(onSizeChange: $0) }
}
