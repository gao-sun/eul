//
//  StatusBarManager.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import Combine

class StatusBarManager {
    @ObservedObject var preferenceStore = PreferenceStore.shared
    private var activeCancellable: AnyCancellable?
    private var displayCancellable: AnyCancellable?
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
        activeCancellable = preferenceStore.$activeComponents.sink {
            self.render(components: $0)
        }
        displayCancellable = preferenceStore.$textDisplay.sink { _ in
            self.itemDict.values.forEach { $0.refresh() }
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
