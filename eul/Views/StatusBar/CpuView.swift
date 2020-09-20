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
        [cpuStore.usage, cpuStore.temp.map { SmcControl.shared.formatTemp($0) }].compactMap { $0 }
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("CPU")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            StatusBarTextView(texts: texts)
        }
    }
}
