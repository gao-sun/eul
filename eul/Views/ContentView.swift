//
//  ContentView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @State var activeSection: Preference.Section = .general

    var body: some View {
        HSplitView {
            VStack(spacing: 4) {
                ForEach(Preference.Section.allCases) {
                    Preference.PreferenceSectionView(activeSection: $activeSection, section: $0)
                }
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal, 8)
            .frame(width: 150)
            .background(Color.controlBackground)
            VStack(alignment: .leading, spacing: 12) {
                if activeSection == .general {
                    SectionView(title: "ui.app") {
                        Preference.GeneralView()
                    }
                    SectionView(title: "ui.display") {
                        Preference.DisplayView()
                    }
                    SectionView(title: "ui.refresh_rate") {
                        Preference.RefreshRateView()
                    }
                }
                if activeSection == .components {
                    SectionView(title: "ui.display") {
                        Preference
                            .ComponentsView()
                            .padding(.top, 8)
                    }
                }
                if activeSection == .menuView {
                    SectionView(title: "ui.display") {
                        Preference.PreferenceMenuViewView()
                    }
                }
                Spacer()
            }
            .padding(20)
        }
        .frame(height: 400)
        .id(preferenceStore.language)
    }
}
