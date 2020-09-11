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
            Text("Summary")
                .menuSection()
            HStack {
                Text("Total")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.total))
            }
            HStack {
                Text("Free")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.free))
            }
            HStack {
                Text("Cached Files")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.cachedFiles))
            }
            memoryStore.temp.map { temp in
                HStack {
                    Text("Temp")
                    Spacer()
                    Text(String(format: "%.0f°C", temp))
                }
            }
            Text("Usage")
                .menuSection()
            HStack {
                Text("App")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.appMemory))
            }
            HStack {
                Text("Wired")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.wired))
            }
            HStack {
                Text("Compressed")
                Spacer()
                Text(MemoryStore.memoryUnit(memoryStore.compressed))
            }
        }
        .frame(width: 180)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
