//
//  ContentView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var preferenceStore = PreferenceStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionView(title: "ui.general") {
                Preference.GeneralView()
            }
            SectionView(title: "ui.display") {
                Preference.DisplayView()
            }
            SectionView(title: "ui.components") {
                Preference
                    .ComponentsView()
                    .padding(.top, 8)
            }
        }
        .padding(20)
        .frame(minWidth: 610)
        .environmentObject(preferenceStore)
        .id(preferenceStore.language)
    }
}
