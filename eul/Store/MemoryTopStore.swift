//
//  MemoryTopStore.swift
//  eul
//
//  Created by Jevon Mao on 1/19/21.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI
import Combine
import SystemKit

class MemoryTopStore: ObservableObject {
    private var memorySizeMB = System.physicalMemory() * 1000
    private var task: Process?
    private var activeCancellable: AnyCancellable?
    private var firstLoaded = false
    @ObservedObject var preferenceStore = SharedStore.preference
    @Published var dataAvailable = false
    @Published var topProcesses: [RamUsage] = []
    
    
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
        let refreshRate = preferenceStore.smcRefreshRate
        firstLoaded = false
        dataAvailable = false
        topProcesses = []
        task = shellPipe("top -l 0 -n 5 -stats pid,command,rsize -s \(refreshRate) -orsize"){string in
            let rows = string.split(separator: "\n", omittingEmptySubsequences: false).map { String($0) }
            
            guard let separatorIndex = rows.firstIndex(of: "") else {
                return
            }
            
            if rows.indices.contains(separatorIndex + 1) {
                let titleRow = rows[separatorIndex + 1].lowercased()
                if titleRow.contains("pid"), titleRow.contains("mem"), titleRow.contains("command") {
                    let runningApps = NSWorkspace.shared.runningApplications 
                    let result: [RamUsage] = ((separatorIndex + 2)..<rows.count).compactMap { index in
                        let row = rows[index].split(separator: " ").map { String($0) }
                        guard row.count >= 2, let pid = Int(row[0]),let rawRamString = row.last, let ram = Double(rawRamString.filter("0123456789.".contains)) else {
                            return nil
                        }
                        
                        let usage = 100 * (ram/self.memorySizeMB)
                        
                        return RamUsage(pid: pid, command: Info.getProcessCommand(pid: pid)!, percentage: usage, usageAmount: ram, runningApp: runningApps.first(where: {$0.processIdentifier == pid}))
                    }
                    Print("RAM top is updating")
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
        activeCancellable = Publishers
            .CombineLatest(
                SharedStore.menuComponents.$activeComponents,
                SharedStore.ui.$menuOpened
            )
            .map {
                $0.contains(.Memory) && $1
            }
            .sink { [self] in
                update(shouldStart: $0)
            }
    }
}
