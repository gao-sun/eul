//
//  CpuInfo.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct CpuEntry: SharedEntry {
    static let containerKey = "CpuEntry"

    var date = Date()
    let temp: Double?
    let usageSystem: Double?
}
