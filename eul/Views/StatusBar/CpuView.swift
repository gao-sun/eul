//
//  CpuView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuView: View {
    @EnvironmentObject var cpuStore: CpuStore
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        [cpuStore.usageString]
    }

    var textWidth: CGFloat? {
        guard preferenceStore.textDisplay == .compact else {
            return nil
        }
        return preferenceStore.fontDesign == .default ? 40 : 45
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("CPU")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            StatusBarTextView(texts: texts)
                .frame(width: textWidth)
        }
    }
}
