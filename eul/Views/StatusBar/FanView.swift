//
//  FanView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FanView: View {
    @EnvironmentObject var fanStore: FanStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore

    var config: EulComponentConfig {
        componentConfigStore[.Fan]
    }

    var texts: [String] {
        fanStore.fans.map { "\($0.speed.description) rpm" }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Fan")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
//            if config.showText {
            StatusBarTextView(texts: texts)
                .stableWidth()
//            }
        }
    }
}
