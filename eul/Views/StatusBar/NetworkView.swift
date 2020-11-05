//
//  NetworkView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var networkStore: NetworkStore
    @EnvironmentObject var preferenceStore: PreferenceStore

    var texts: [String] {
        [networkStore.outSpeed, networkStore.inSpeed]
    }

    var body: some View {
        HStack(spacing: 6) {
            if preferenceStore.showIcon {
                Image("Network")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            StatusBarTextView(texts: texts)
                .stableWidth(20)
        }
    }
}
