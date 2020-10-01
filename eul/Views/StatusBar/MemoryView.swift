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

    var textWidth: CGFloat? {
        guard preferenceStore.textDisplay == .compact else {
            return nil
        }
        let maxNumber = texts.reduce(0) { max($0, ($1.numericOnly as NSString).integerValue) }
        return preferenceStore.fontDesign == .default
            ? 35 + 2.5 * CGFloat(maxNumber.digitCount)
            : 40 + 4 * CGFloat(maxNumber.digitCount)
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("Memory")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            StatusBarTextView(texts: texts)
                .frame(width: textWidth)
        }
    }
}
