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
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        [memoryStore.freeString, memoryStore.usedString]
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("Memory")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            StatusBarTextView(texts: texts)
        }
    }
}
