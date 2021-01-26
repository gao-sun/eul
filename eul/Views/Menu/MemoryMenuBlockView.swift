//
//  MemoryMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct MemoryMenuBlockView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var memoryStore: MemoryStore
    @EnvironmentObject var memoryTopStore: TopStore

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
            if preferenceStore.showRAMTopActivities {
                SeparatorView()
                VStack(spacing: 8) {
                    if !memoryTopStore.ramDataAvailable {
                        Spacer()
                        Text("cpu.waiting_status_report".localized())
                            .secondaryDisplayText()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    } else {
                        ForEach(memoryTopStore.ramTopProcesses) { process in
                            ProcessRowView(section: "cpu", process: process) {
                                AnyView(
                                    HStack {
                                        Text("\(ByteUnit(megaBytes: process.usageAmount).readable)")
                                            .displayText()
                                            .frame(alignment: .trailing)
                                        Text(process.value.toFixed(1) + "%")
                                            .displayText()
                                            .frame(width: 35, alignment: .trailing)
                                    }
                                )
                            }
                        }
                    }
                }
                .frame(minWidth: 311)
                .frame(height: 102)
            }
        }
        .menuBlock()
    }
}
