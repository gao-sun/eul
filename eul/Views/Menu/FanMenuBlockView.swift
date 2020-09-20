//
//  FanMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FanMenuBlockView: View {
    @ObservedObject var fanStore = FanStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("fan".localized())
                .menuSection()
            ForEach(fanStore.fans) { fan in
                Text("\("fan".localized()) \(fan.id + 1)")
                    .miniSection()
                    .padding(.top, 4)
                ProgressBarView(
                    percentage: CGFloat(fan.percentage),
                    textWidth: 55,
                    customText: "\(fan.speed.description) rpm"
                )
            }
        }
        .padding(.top, 2)
        .menuBlock()
    }
}
