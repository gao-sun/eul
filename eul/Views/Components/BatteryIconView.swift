//
//  BatteryIconView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/13.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryIconView: View {
    private let lengthUnit: CGFloat = 15.0 / 100
    var isCharging = false
    var charge: Double = 0

    var chargeFloat: CGFloat {
        (charge.isNaN || charge.isInfinite) ? 100 : CGFloat(charge * 100)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if isCharging {
                Image("BatteryCharging")
                    .resizable()
                    .frame(width: 18, height: 18)
            } else {
                Image("BatteryEmpty")
                    .resizable()
                    .frame(width: 18, height: 18)
                Rectangle()
                    .frame(width: chargeFloat * lengthUnit, height: 8)
                    .offset(x: 1)
            }
        }
    }
}
