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
    private var lastTimestamp: TimeInterval

    @Published var inSpeedInByte: Double = 0
    @Published var outSpeedInByte: Double = 0

    var inSpeed: String {
        ByteUnit(inSpeedInByte).readable
    }

    var outSpeed: String {
        ByteUnit(outSpeedInByte).readable
    }

    @objc func refresh() {
        let current = Info.Network()
        let time = Date().timeIntervalSince1970

        if current.inBytes >= network.inBytes {
            inSpeedInByte = Double(current.inBytes - network.inBytes) / (time - lastTimestamp)
        } else {
            inSpeedInByte = 0
        }

        if current.outBytes >= network.outBytes {
            outSpeedInByte = Double(current.outBytes - network.outBytes) / (time - lastTimestamp)
        } else {
            outSpeedInByte = 0
        }

        lastTimestamp = time
    }

    init() {
        lastTimestamp = Date().timeIntervalSince1970
        initObserver(for: .StoreShouldRefresh)
    }
}
