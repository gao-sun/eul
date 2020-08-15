//
//  ContentView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionView(title: "Display") {
                Preference.DisplayView()
            }
            SectionView(title: "Components") {
                Preference.ComponentsView()
            }
        }
        .padding(20)
        .frame(minWidth: 610)
        .environmentObject(PreferenceStore.shared)
    }
}
