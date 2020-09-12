//
//  MemoryMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct MemoryMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var memoryStore = MemoryStore.shared

    var body: some View {
        VStack(spacing: 2) {
            Text("menu.summary".localized())
                .menuSection()
            HStack {
                Text("memory.total".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.total))
            }
            HStack {
                Text("memory.free".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.free))
            }
            HStack {
                Text("memory.cached_files".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.cachedFiles))
            }
            memoryStore.temp.map { temp in
                HStack {
                    Text("memory.temp".localized())
                    Spacer()
                    Text(SmcControl.shared.formatTemp(temp))
                }
            }
            Text("memory.usage".localized())
                .menuSection()
            HStack {
                Text("memory.app".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.appMemory))
            }
            HStack {
                Text("memory.wired".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.wired))
            }
            HStack {
                Text("memory.compressed".localized())
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.compressed))
            }
        }
        .frame(width: 180)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
