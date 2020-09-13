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
    var charge = 0

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
                    .frame(width: CGFloat(charge) * lengthUnit, height: 8)
                    .foregroundColor(.white)
                    .offset(x: 1)
            }
        }
    }
}
