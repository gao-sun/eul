//
//  BatteryView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct BatteryView: View {
    private let lengthUnit: CGFloat = 15.0 / 100
    @EnvironmentObject var batteryStore: BatteryStore

    var body: some View {
        HStack(spacing: 6) {
            ZStack(alignment: .leading) {
                Image("Battery")
                    .resizable()
                    .frame(width: 18, height: 18)
                Rectangle()
                    .frame(width: CGFloat(batteryStore.charge) * lengthUnit, height: 8)
                    .foregroundColor(.white)
                    .offset(x: 1)
            }
            Text("\(batteryStore.charge)%")
                .normal()
        }
    }
}
