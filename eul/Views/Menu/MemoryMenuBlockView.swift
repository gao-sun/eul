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
                Text(memoryStore.used.memoryString)
                    .displayText()
                Text("memory.usage".localized())
                    .miniSection()
                Text(memoryStore.allFree.memoryString)
                    .displayText()
                Text("memory.free".localized())
                    .miniSection()
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
        }
        .menuBlock()
    }
}
