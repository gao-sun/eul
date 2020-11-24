//
//  ContentView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var componentsStore: ComponentsStore<EulComponent>
    @EnvironmentObject var uiStore: UIStore

    var body: some View {
        HStack {
            VStack(spacing: 4) {
                ForEach(Preference.Section.allCases) {
                    Preference.PreferenceSectionView(activeSection: $uiStore.activeSection, section: $0)
                }
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 8)
            .frame(width: 150)
            .background(Color.controlBackground)
            ScrollView([.vertical], showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    if uiStore.activeSection == .general {
                        SectionView(title: "ui.app".localized()) {
                            Preference.GeneralView()
                        }
                        SectionView(title: "ui.display".localized()) {
                            Preference.DisplayView()
                        }
                        SectionView(title: "ui.refresh_rate".localized()) {
                            Preference.RefreshRateView()
                        }
                    }
                    if uiStore.activeSection == .components {
                        SectionView(title: "ui.display".localized()) {
                            Preference
                                .ComponentsView()
                                .padding(.top, 8)
                        }
                        if componentsStore.showComponents {
                            ForEach(EulComponent.allCases) {
                                Preference.ComponentConfigView(component: $0)
                            }
                        }
                    }
                    if uiStore.activeSection == .menuView {
                        SectionView(title: "ui.display".localized()) {
                            Preference.PreferenceMenuViewView()
                        }
                    }
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
            }
            .clipped()
        }
        .frame(height: 400)
        .id(preferenceStore.language)
    }
}
