//
//  StatusMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusMenuView: SizeChangeView {
    @EnvironmentObject var uiStore: UIStore
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var menuComponentsStore: ComponentsStore<EulMenuComponent>

    var onSizeChange: ((CGSize) -> Void)?
    var body: some View {
        if preferenceStore.appearanceMode == .light {
            base
                .environment(\.colorScheme, .light)
        } else if preferenceStore.appearanceMode == .dark {
            base
                .environment(\.colorScheme, .dark)
        } else {
            base
        }
    }

    var base: some View {
        VStack(spacing: 12) {
            HStack {
                Text("eul")
                    .font(.system(size: 12, weight: .semibold))
                Text("v\(preferenceStore.version ?? "?")")
                    .secondaryDisplayText()
                Spacer()
                MenuActionTextView(id: "menu.preferences", text: "menu.preferences", action: AppDelegate.openPreferences)
                MenuActionTextView(id: "menu.quit", text: "menu.quit", action: AppDelegate.quit)
            }
            ForEach(menuComponentsStore.activeComponents) {
                $0.getView()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .frame(minWidth: uiStore.menuWidth)
        .fixedSize()
        .animation(.none)
        .background(GeometryReader { self.reportSize($0) })
        .onPreferenceChange(SizePreferenceKey.self, perform: { value in
            if let size = value.first {
                onSizeChange?(size)
            }
        })
        .onAppear {
            print(preferenceStore.appearanceMode)
        }
    }
}
