//
//  DiskView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct DiskView: View {
    @EnvironmentObject var diskStore: DiskStore
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        [diskStore.usageString, diskStore.freeString]
    }

    var textWidth: CGFloat? {
        guard preferenceStore.textDisplay == .compact else {
            return nil
        }
        let maxNumber = texts.reduce(0) { max($0, ($1.numericOnly as NSString).integerValue) }
        return preferenceStore.fontDesign == .default
            ? 30 + 2.5 * CGFloat(maxNumber.digitCount)
            : 35 + 3.5 * CGFloat(maxNumber.digitCount)
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("Disk")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            StatusBarTextView(texts: texts)
                .frame(width: textWidth, alignment: .trailing)
        }
    }
}
