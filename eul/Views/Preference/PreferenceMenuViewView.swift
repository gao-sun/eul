//
//  PreferenceMenuViewView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/18.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct PreferenceMenuViewView: View {
        @EnvironmentObject var preference: PreferenceStore

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: $preference.showTopActivities) {
                    Text("menu.show_top_activities".localized())
                }
            }
            .padding(.vertical, 8)
        }
    }
}
