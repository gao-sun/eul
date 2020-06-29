//
//  FanStore.swift
//  eul
//
//  Created by Gao Sun on 2020/6/29.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class FanStore: ObservableObject, Refreshable {
    static let shared = FanStore()

    @Published var fans: [SmcControl.FanData] = []

    @objc func refresh() {
        fans = SmcControl.shared.fans
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
