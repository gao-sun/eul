//
//  TopStore.swift
//  eul
//
//  Created by Jevon Mao on 1/22/21.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Combine
import SwiftUI
import SystemKit

class TopStore: ObservableObject {
    private var memorySizeMB = System.physicalMemory() * 1000
    private var ramTask: Process?
    private var cpuTask: Process?
    private var activeCancellable: AnyCancellable?
    private var firstLoaded = false
    @ObservedObject var preferenceStore = SharedStore.preference
    @Published var cpuDataAvailable = false
    @Published var ramDataAvailable = false
    @Published var cpuTopProcesses: [ProcessCpuUsage] = []
    @Published var ramTopProcesses: [RamUsage] = []

    enum taskType {
        case cpu
        case ram
    }

    func update(shouldStart: Bool) {
        guard shouldStart else {
            ramTask?.terminate()
            ramTask = nil
            cpuTask?.terminate()
            cpuTask = nil
            return
        }

        if cpuTask != nil {
            Print("cpu task already started")
            return
        } else if ramTask != nil {
            Print("ram task already started")
            return
        }
        let refreshRate = preferenceStore.smcRefreshRate
        firstLoaded = false
        cpuDataAvailable = false
        ramDataAvailable = false
        ramTopProcesses = []; cpuTopProcesses = []

        // MARK: Parsing command for CPU top processes

        parseTerminalCommand(taskType: .cpu, commandString: "top -l 0 -u -n 5 -stats pid,cpu,command -s \(refreshRate)") { separatorIndex, rows, titleRow in
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
                        percentage: cpu,
                        runningApp: runningApps.first(where: { $0.processIdentifier == pid })
                    )
                }

                Print("CPU top is updating")
                DispatchQueue.main.async { [self] in
                    cpuTopProcesses = result
                    if !firstLoaded {
                        firstLoaded = true
                    } else if !cpuDataAvailable {
                        cpuDataAvailable = true
                    }
                }
            }
        }

        // MARK: Parsing command for RAM top processes

        parseTerminalCommand(taskType: .ram, commandString: "top -l 0 -n 6 -stats pid,command,rsize -s \(refreshRate) -orsize") { separatorIndex, rows, titleRow in
            if titleRow.contains("pid"), titleRow.contains("mem"), titleRow.contains("command") {
                let runningApps = NSWorkspace.shared.runningApplications
                let result: [RamUsage] = ((separatorIndex + 2)..<rows.count).compactMap { index in
                    let row = rows[index].split(separator: " ").map { String($0) }
                    guard row.count >= 2, let pid = Int(row[0]), let rawRamString = row.last, let ram = Double(rawRamString.filter("0123456789.".contains)), pid != 0 else {
                        return nil
                    }

                    let usage = 100 * (ram / self.memorySizeMB)

                    return RamUsage(pid: pid, command: Info.getProcessCommand(pid: pid)!, percentage: usage, usageAmount: ram, runningApp: runningApps.first(where: { $0.processIdentifier == pid }))
                }
                DispatchQueue.main.async { [self] in
                    ramTopProcesses = result.count <= 5 ? result.dropLast(0) : result.dropLast(1)
                    if !firstLoaded {
                        firstLoaded = true
                    } else if !ramDataAvailable {
                        ramDataAvailable = true
                    }
                }
            }
        }
    }

    func parseTerminalCommand(taskType: taskType, commandString: String, completion: @escaping (Int, [String], String) -> Void) {
        let task = shellPipe(commandString) { string in
            let rows = string.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

            guard let separatorIndex = rows.firstIndex(of: "") else {
                return
            }

            if rows.indices.contains(separatorIndex + 1) {
                let titleRow = rows[separatorIndex + 1].lowercased()
                completion(separatorIndex, rows, titleRow)
            }
        }
        switch taskType {
        case .cpu:
            cpuTask = task
        case .ram:
            ramTask = task
        }
    }

    init() {
        activeCancellable = Publishers
            .CombineLatest3(
                preferenceStore.$showCPUTopActivities,
                SharedStore.menuComponents.$activeComponents,
                SharedStore.ui.$menuOpened
            )
            .map {
                $0 && $1.contains(.CPU) && $2
            }
            .sink { [self] in
                update(shouldStart: $0)
            }
    }
}

struct ProcessCpuUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    let percentage: Double
    let runningApp: NSRunningApplication?
}

struct RamUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    var percentage: Double
    let usageAmount: Double
    let runningApp: NSRunningApplication?
}
