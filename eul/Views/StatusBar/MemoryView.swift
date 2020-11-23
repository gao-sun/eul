//
//  MemoryView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/29.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct MemoryView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore

    var config: EulComponentConfig {
        componentConfigStore[.Memory]
    }

    var texts: [String] {
        [memoryStore.freeString, memoryStore.usedString]
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Memory")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            StatusBarTextView(texts: texts)
                .stableWidth()
        }
    }
}
