//
//  CpuTopStore.swift
//  eul
//
//  Created by Gao Sun on 2020/10/16.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class CpuTopStore: ObservableObject {
    struct ProcessCpuUsage: ProcessUsage {
        typealias T = Double
        let pid: Int
        let command: String
        let value: Double
    }

    static let shared = CpuTopStore()

    @Published var topProcesses: [ProcessCpuUsage] = []

    init() {
        shellPipe("top -l0 -u -n 5 -stats pid,cpu,command -s 2") { string in
            let rows = string.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }

            guard let separatorIndex = rows.firstIndex(of: "") else {
                return
            }

            if rows.indices.contains(separatorIndex + 1) {
                let titleRow = rows[separatorIndex + 1].lowercased()
                if titleRow.contains("pid"), titleRow.contains("cpu"), titleRow.contains("command") {
                    self.topProcesses = ((separatorIndex + 2)..<rows.count).compactMap { index in
                        let row = rows[index].split(separator: " ").map { String($0) }
                        guard row.count >= 3, let pid = Int(row[0]), let cpu = Double(row[1]), cpu >= 0.1 else {
                            return nil
                        }
                        return ProcessCpuUsage(pid: pid, command: Info.getProcessCommand(pid: pid) ?? row[2], value: cpu)
                    }
                }
            }
        }
    }
}
