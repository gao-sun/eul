//
//  FanMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FanMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var fanStore = FanStore.shared

    var body: some View {
        VStack(spacing: 2) {
            ForEach(fanStore.fans) { fan in
                Text("Fan \(fan.id + 1)")
                    .menuSection()
                HStack {
                    Text("Current")
                    Spacer()
                    Text("\(fan.speed.description) rpm")
                }
                HStack {
                    Text("Min Speed")
                    Spacer()
                    Text("\(fan.fan.minSpeed.description) rpm")
                }
                HStack {
                    Text("Max Speed")
                    Spacer()
                    Text("\(fan.fan.maxSpeed.description) rpm")
                }
            }
        }
        .frame(width: 200)
        .menuInfo()
        .background(GeometryReader { self.reportSize($0) })
    }
}
