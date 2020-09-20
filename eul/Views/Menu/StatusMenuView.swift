//
//  StatusMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                CpuMenuBlockView()
                FanMenuBlockView()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .fixedSize()
        .background(GeometryReader { self.reportSize($0) })
    }
}
