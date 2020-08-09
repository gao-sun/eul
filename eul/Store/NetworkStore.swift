//
//  NetworkStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/9.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class NetworkStore: ObservableObject, Refreshable {
    static let shared = NetworkStore()

    private var network = Info.Network()

    @objc func refresh() {
        network = Info.Network()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
