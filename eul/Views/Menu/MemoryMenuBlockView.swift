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
    @EnvironmentObject var memoryStore: MemoryStore

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
                Text(MemoryStore.memoryUnit(memoryStore.used))
                    .displayText()
                Text("memory.usage".localized())
                    .miniSection()
                Text(MemoryStore.memoryUnit(memoryStore.allFree))
                    .displayText()
                Text("memory.free".localized())
                    .miniSection()
            }
            SeparatorView()
            HStack {
                MiniSectionView(title: "memory.cached_files", value: MemoryStore.memoryUnit(memoryStore.cachedFiles))
                Spacer()
                MiniSectionView(title: "memory.app", value: MemoryStore.memoryUnit(memoryStore.appMemory))
                Spacer()
                MiniSectionView(title: "memory.wired", value: MemoryStore.memoryUnit(memoryStore.wired))
                Spacer()
                MiniSectionView(title: "memory.compressed", value: MemoryStore.memoryUnit(memoryStore.compressed))
                memoryStore.temp.map { temp in
                    Group {
                        Spacer()
                        MiniSectionView(title: "memory.temp", value: SmcControl.shared.formatTemp(temp))
                    }
                }
            }
        }
        .menuBlock()
    }
}
