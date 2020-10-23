//
//  PreferenceRefreshRateView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct RefreshRateView: View {
        let allIntervals: [Int] = [1, 3, 5]
        @EnvironmentObject var preference: PreferenceStore

        var body: some View {
            HStack(spacing: 12) {
                Picker("ui.network".localized(), selection: $preference.networkRefreshRate) {
                    ForEach(allIntervals, id: \.self) {
                        Text("\($0)s")
                            .tag($0)
                    }
                }
                .frame(width: 150)
            }
            .padding(.vertical, 8)
        }
    }
}
