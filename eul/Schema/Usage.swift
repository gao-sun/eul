//
//  Usage.swift
//  eul
//
//  Created by Gao Sun on 2021/1/26.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Cocoa
import Foundation

struct ProcessCpuUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    let value: Double
    let runningApp: NSRunningApplication?
}

struct RamUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    var value: Double
    let usageAmount: Double
    let runningApp: NSRunningApplication?
}
