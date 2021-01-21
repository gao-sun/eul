//
//  ProcessUsage.swift
//  eul
//
//  Created by Gao Sun on 2020/10/16.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import AppKit
import Foundation

protocol ProcessUsage: Identifiable {
    associatedtype T: CustomStringConvertible
    var pid: Int { get }
    var command: String { get }
    var percentage: T { get }
    var displayName: String { get }
    var runningApp: NSRunningApplication? { get }
}

struct RamUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    var percentage: Double
    let usageAmount: Double
    let runningApp: NSRunningApplication?
}

extension ProcessUsage {
    var id: Int {
        pid
    }

    var displayName: String {
        let paths = command.split(separator: "/").map { String($0) }
        if let app = paths.last(where: { $0.hasSuffix(".app") }) {
            return app
        }
        return paths.last ?? command
    }
}
