//
//  BatteryIconView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/13.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct BatteryIconView: View {
    public init(size: CGFloat = 16, isCharging: Bool = false, charge: Double = 0, acPowered: Bool = false) {
        self.size = size
        self.isCharging = isCharging
        self.charge = charge
        self.acPowered = acPowered
        print("I'm changed too")
    }

    public var size: CGFloat = 16
    public var isCharging = false
    public var charge: Double = 0
    public var acPowered = false

    private var lengthUnit: CGFloat {
        size * 15 / 18 / 100
    }

    public var chargeFloat: CGFloat {
        (charge.isNaN || charge.isInfinite) ? 100 : CGFloat(charge * 100)
    }

    public var body: some View {
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
