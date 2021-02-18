//
//  StatusBarManager.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import SwiftUI

class StatusBarManager {
    static let shared = StatusBarManager()

    @ObservedObject var preferenceStore = SharedStore.preference
    @ObservedObject var componentsStore = SharedStore.components
    private var activeCancellable: AnyCancellable?
    private var displayCancellable: AnyCancellable?
    private var showComponentsCancellable: AnyCancellable?
    private var showIconCancellable: AnyCancellable?
    private var fontDesignCancellable: AnyCancellable?
    private var appearanceModeCancellable: AnyCancellable?
    private let item = StatusBarItem()

    init() {
        // w/o the delay items will have a chance of not appearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subscribe()
        }
    }

    func checkVisibilityIfNeeded() {
        item.checkVisibilityIfNeeded()
    }

    func subscribe() {
        // TO-DO: refactor
        activeCancellable = SharedStore.components.$activeComponents.sink {
            self.render(components: $0)
        }
        displayCancellable = preferenceStore.$textDisplay.sink { _ in
            self.refresh()
        }
        showComponentsCancellable = SharedStore.components.$showComponents.sink { _ in
            self.refresh()
        }
        showIconCancellable = preferenceStore.$showIcon.sink { _ in
            self.refresh()
        }
        fontDesignCancellable = preferenceStore.$fontDesign.sink { _ in
            self.refresh()
        }
        appearanceModeCancellable = preferenceStore.$appearanceMode.sink { value in
            self.changeColorScheme(to: Preference.appearance(rawValue: value.rawValue) ?? .auto)
        }
    }

    func refresh() {
        DispatchQueue.main.async {
            self.item.refresh()
        }
    }

    func render(components _: [EulComponent]) {
        item.isVisible = false

        DispatchQueue.main.async {
            self.item.isVisible = true
        }
    }

    func changeNSWindowColorScheme(to color: NSAppearance.Name?) {
        if let color = color {
            item.changeNSWindowColorScheme(to: color)
        } else {
            item.changeNSWindowColorScheme(to: nil)
        }
    }

    func changeColorScheme(to appearance: Preference.appearance) {
        let window = NSApplication.shared.mainWindow
        if appearance == .light {
            let appearence = NSAppearance(named: .aqua)
            window?.appearance = appearence
            StatusBarManager.shared.changeNSWindowColorScheme(to: .aqua)

        } else if appearance == .dark {
            let appearence = NSAppearance(named: .darkAqua)
            window?.appearance = appearence
            StatusBarManager.shared.changeNSWindowColorScheme(to: .darkAqua)

        } else {
            window?.appearance = nil
            StatusBarManager.shared.changeNSWindowColorScheme(to: nil)
        }
    }
}
