//
//  NetworkView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var networkStore: NetworkStore
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        [networkStore.outSpeed, networkStore.inSpeed]
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
                Image("Network")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            StatusBarTextView(texts: texts)
                .frame(width: textWidth)
        }
    }
}
