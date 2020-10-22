//
//  StatusMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusMenuView: SizeChangeView {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var batteryStore: BatteryStore

    func openPreferences() {
        (NSApp.delegate as! AppDelegate).window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        NotificationCenter.default.post(name: .StatusBarMenuShouldClose, object: nil)
    }

    func quit() {
        NSApplication.shared.terminate(self)
    }

    var onSizeChange: ((CGSize) -> Void)?
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("eul")
                    .font(.system(size: 12, weight: .semibold))
                Text("v\(PreferenceStore.shared.version ?? "?")")
                    .secondaryDisplayText()
                Spacer()
                MenuActionTextView(id: "menu.preferences", text: "menu.preferences", action: openPreferences)
                MenuActionTextView(id: "menu.quit", text: "menu.quit", action: quit)
            }
            ForEach(preferenceStore.activeMenuComponents) { component in
                component.getMenuView()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .fixedSize()
        .animation(.none)
        .background(GeometryReader { self.reportSize($0) })
    }
}
