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
    @ObservedObject var preferenceStore = PreferenceStore.shared
    private var activeCancellable: AnyCancellable?
    private var displayCancellable: AnyCancellable?
    private var showIconCancellable: AnyCancellable?
    private var languageCancellable: AnyCancellable?
    var itemDict: [EulComponent: StatusBarItem] = [:]

    init() {
        EulComponent.allCases.forEach {
            self.itemDict[$0] = StatusBarItem(with: $0)
        }

        // w/o the delay items will have a chance of not appearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subscribe()
        }
    }

    func subscribe() {
        languageCancellable = preferenceStore.$language.sink { _ in
            self.updateLanguage()
        }
        activeCancellable = preferenceStore.$activeComponents.sink {
            self.render(components: $0)
        }
        displayCancellable = preferenceStore.$textDisplay.sink { _ in
            self.refresh()
        }
        showIconCancellable = preferenceStore.$showIcon.sink { _ in
            self.refresh()
        }
    }

    func refresh() {
        itemDict.values.forEach { $0.refresh() }
    }

    func updateLanguage() {
        itemDict.values.forEach {
            $0.updateLanguage()
        }
    }

    func render(components: [EulComponent]) {
        EulComponent.allCases.forEach {
            self.itemDict[$0]?.isVisible = false
        }

        components.reversed().forEach {
            self.itemDict[$0]?.isVisible = true
        }
    }
}
