//
//  CpuTopStore.swift
//  eul
//
//  Created by Gao Sun on 2020/10/16.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import AppKit
import Combine
import SwiftUI

class CpuTopStore: ObservableObject {
    struct ProcessCpuUsage: ProcessUsage {
        typealias T = Double
        let pid: Int
        let command: String
        let value: Double
        let runningApp: NSRunningApplication?
    }

    static let shared = CpuTopStore()

    private var task: Process?
    private var activeCancellable: AnyCancellable?
    private var firstLoaded = false
    @ObservedObject var preferenceStore = PreferenceStore.shared
    @Published var dataAvailable = false
    @Published var topProcesses: [ProcessCpuUsage] = []

    func update(shouldStart: Bool) {
        guard shouldStart else {
            task?.terminate()
            task = nil
            return
        }

        if task != nil {
            Print("cpu task already started")
            return
        }

        firstLoaded = false
        dataAvailable = false
        topProcesses = []
        task = shellPipe("top -l 0 -u -n 5 -stats pid,cpu,command -s 3") { [self] string in
            let rows = string.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

            guard let separatorIndex = rows.firstIndex(of: "") else {
                return
            }

            if rows.indices.contains(separatorIndex + 1) {
                let titleRow = rows[separatorIndex + 1].lowercased()
                if titleRow.contains("pid"), titleRow.contains("cpu"), titleRow.contains("command") {
                    let runningApps = NSWorkspace.shared.runningApplications
                    let result: [ProcessCpuUsage] = ((separatorIndex + 2)..<rows.count).compactMap { index in
                        let row = rows[index].split(separator: " ").map { String($0) }
                        guard row.count >= 3, let pid = Int(row[0]), let cpu = Double(row[1]), cpu >= 0.1 else {
                            return nil
                        }
                        return ProcessCpuUsage(
                            pid: pid,
                            command: Info.getProcessCommand(pid: pid) ?? row[2],
                            value: cpu,
                            runningApp: runningApps.first(where: { $0.processIdentifier == pid })
                        )
                    }

                    Print("CPU top is updating")
                    DispatchQueue.main.async { [self] in
                        topProcesses = result
                        if !firstLoaded {
                            firstLoaded = true
                        } else if !dataAvailable {
                            dataAvailable = true
                        }
                    }
                }
            }
        }
    }

    init() {
        update(shouldStart: preferenceStore.showTopActivities)
        activeCancellable = preferenceStore.$showTopActivities.sink { [self] in
            update(shouldStart: $0)
        }
    }
}
