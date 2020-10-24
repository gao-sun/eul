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
    @ObservedObject var componentsStore = sharedComponentsStore
    private var activeCancellable: AnyCancellable?
    private var displayCancellable: AnyCancellable?
    private var showComponentsCancellable: AnyCancellable?
    private var showIconCancellable: AnyCancellable?
    private var fontDesignCancellable: AnyCancellable?
    private let item = StatusBarItem()

    init() {
        // w/o the delay items will have a chance of not appearing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.subscribe()
        }
    }

    func subscribe() {
        // TO-DO: refactor
        activeCancellable = sharedComponentsStore.$activeComponents.sink {
            self.render(components: $0)
        }
        displayCancellable = preferenceStore.$textDisplay.sink { _ in
            self.refresh()
        }
        showComponentsCancellable = sharedComponentsStore.$showComponents.sink { _ in
            self.refresh()
        }
        showIconCancellable = preferenceStore.$showIcon.sink { _ in
            self.refresh()
        }
        fontDesignCancellable = preferenceStore.$fontDesign.sink { _ in
            self.refresh()
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
}
