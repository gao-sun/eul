//
//  FanMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FanMenuBlockView: View {
    @EnvironmentObject var fanStore: FanStore

    var body: some View {
        HStack(spacing: 4) {
            Text("fan".localized())
                .menuSection()
            Spacer()
            HStack {
                ForEach(fanStore.fans) { fan in
                    MiniSectionView(
                        title: "\("fan".localized()) \(fan.id + 1)",
                        value: fan.currentSpeedString
                    )
                    .frame(width: 80)
                }
            }
        }
        .padding(.top, 2)
        .menuBlock()
    }
}
