//
//  BatteryIconView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/13.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryIconView: View {
    var size: CGFloat = 16
    var isCharging = false
    var charge: Double = 0
    var acPowered = false

    private var lengthUnit: CGFloat {
        size * 15 / 18 / 100
    }

    var chargeFloat: CGFloat {
        (charge.isNaN || charge.isInfinite) ? 100 : CGFloat(charge * 100)
    }

    var body: some View {
        ZStack(alignment: .leading) {
            if isCharging {
                Image("BatteryCharging")
                    .resizable()
                    .frame(width: size, height: size)
            } else if acPowered {
                Image("BatteryAC")
                    .resizable()
                    .frame(width: size, height: size)
            } else {
                Image("BatteryEmpty")
                    .resizable()
                    .frame(width: size, height: size)
                Rectangle()
                    .frame(width: chargeFloat * lengthUnit, height: 8)
                    .offset(x: 1)
            }
        }
    }
}
