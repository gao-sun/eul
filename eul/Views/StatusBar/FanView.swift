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
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        fanStore.fans.map { "\($0.speed.description) rpm" }
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("Fan")
                    .resizable()
                    .frame(width: 15, height: 15)
            }
            StatusBarTextView(texts: texts)
        }
    }
}
