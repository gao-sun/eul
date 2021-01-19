//
//  MemoryMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI
import SystemKit

struct RamUsage: ProcessUsage {
    typealias T = Double
    let pid: Int
    let command: String
    var percentage: Double
    let usageAmount: Double
    let runningApp: NSRunningApplication?
}

struct MemoryMenuBlockView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    var memorySizeMB = System.physicalMemory() * 1000
    @State var ramProcesses: [RamUsage] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("memory".localized())
                .menuSection()
            HStack {
                ProgressBarView(
                    width: 130,
                    percentage: CGFloat(memoryStore.usedPercentage),
                    showText: false
                )
                Spacer()
                Text("memory.usage".localized())
                    .miniSection()
                Text(memoryStore.used.memoryString)
                    .displayText()
                Text("memory.free".localized())
                    .miniSection()
                Text(memoryStore.allFree.memoryString)
                    .displayText()
            }
            SeparatorView()
            HStack {
                MiniSectionView(title: "memory.cached_files", value: memoryStore.cachedFiles.memoryString)
                Spacer()
                MiniSectionView(title: "memory.app", value: memoryStore.appMemory.memoryString)
                Spacer()
                MiniSectionView(title: "memory.wired", value: memoryStore.wired.memoryString)
                Spacer()
                MiniSectionView(title: "memory.compressed", value: memoryStore.compressed.memoryString)
                memoryStore.temp.map { temp in
                    Group {
                        Spacer()
                        MiniSectionView(title: "memory.temp", value: SmcControl.shared.formatTemp(temp))
                    }
                }
            }
            SeparatorView()
     
            VStack(spacing: 8) {
                ForEach(ramProcesses) {process in
                    RamProcessRowView(section: "cpu", process: process)
                }
            }
            .frame(minWidth: 311)
            .onAppear{
                shellPipe("top -l 0 -n 5 -stats pid,command,rsize -s 3 -orsize"){string in
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
                                
                                let usage = 100 * (ram/memorySizeMB)
                               
                                return RamUsage(pid: pid, command: Info.getProcessCommand(pid: pid)!, percentage: usage, usageAmount: ram, runningApp: runningApps.first(where: {$0.processIdentifier == pid}))
                            }
                            self.ramProcesses = result

                        }
                    }
                }
            }
            
        }
        .menuBlock()
    }
}
