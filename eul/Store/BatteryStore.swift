//
//  BatteryStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SystemKit

class BatteryStore: ObservableObject, Refreshable {
    static let shared = BatteryStore()

    private var battery = Battery()
    private var batteryIO = Info.Battery()
    private let opened = false

    @Published var acPowered = false
    @Published var charged = false
    @Published var charging = false
    var charge: Int {
        batteryIO.currentPercentage
    }

    @objc func refresh() {
        batteryIO = Info.Battery()

        guard battery.open() == kIOReturnSuccess else {
            return
        }

        acPowered = battery.isACPowered()
        charged = battery.isCharged()
        charging = battery.isCharging()
        _ = battery.close()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
