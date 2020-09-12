//
//  FanView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FanView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var fanStore = FanStore.shared

    var texts: [String] {
        fanStore.fans.map { "\($0.speed.description) rpm" }
    }

    var body: some View {
        HStack(spacing: 6) {
            Image("Fan")
                .resizable()
                .frame(width: 15, height: 15)
            StatusBarTextView(texts: texts)
        }
        .fixedSize()
        .background(GeometryReader { self.reportSize($0) })
    }
}
