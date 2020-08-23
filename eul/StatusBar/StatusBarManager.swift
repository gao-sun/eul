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
    private var cancellable: AnyCancellable?
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
        cancellable = preferenceStore.$activeComponents.sink {
            self.render(components: $0)
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
