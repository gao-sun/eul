//
//  ContentView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selected: MenuItem = .General

    var body: some View {
        HSplitView {
            VStack(alignment: .leading, spacing: 4) {
                Text("eul")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(20)
                ForEach(MenuItem.allCases) { item in
                    MenuItemView(item: item, active: self.selected == item)
                        .onTapGesture {
                            self.selected = item
                        }
                }
            }
            .frame(width: 200, alignment: .leading)
            .padding(.bottom, 32)
            VStack {
                Preference.GeneralView()
                Spacer()
            }
            .padding(20)
            .frame(minWidth: 610)
        }
        .environmentObject(PreferenceStore.shared)
    }
}
