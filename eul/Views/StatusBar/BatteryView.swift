//
//  BatteryView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var batteryStore = BatteryStore.shared

    var texts: [String] {
        ["\(batteryStore.charge)%"]
    }

    var body: some View {
        HStack(spacing: 6) {
            BatteryIconView(isCharging: batteryStore.io.isCharging, charge: batteryStore.charge)
            StatusBarTextView(texts: texts)
        }
        .fixedSize()
        .background(GeometryReader { self.reportSize($0) })
    }
}
