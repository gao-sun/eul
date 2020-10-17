//
//  StatusMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusMenuView: SizeChangeView {
    @EnvironmentObject var preferenceStore: PreferenceStore

    var onSizeChange: ((CGSize) -> Void)?
    var body: some View {
        VStack(spacing: 12) {
            CpuMenuBlockView()
            FanMenuBlockView()
            MemoryMenuBlockView()
            BatteryMenuBlockView()
            NetworkMenuBlockMenuView()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .fixedSize()
        .animation(.none)
        .background(GeometryReader { self.reportSize($0) })
    }
}
