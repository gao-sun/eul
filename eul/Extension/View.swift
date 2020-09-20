//
//  View.swift
//  eul
//
//  Created by Gao Sun on 2020/9/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension View {
    func menuInfo() -> some View {
        font(.system(size: 14, weight: .regular))
            .foregroundColor(.info)
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.top, -2)
            .padding(.bottom, 4)
            .fixedSize()
    }

    func menuBlock(radius: CGFloat = 8) -> some View {
        padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.menuBorder, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .fill(Color.textBackground)
                            .brightness(0.05)
                            .blur(radius: 2)
                    )
                    .shadow(color: Color.shadow.opacity(0.1), radius: 5)
            )
    }

    func withGlobalEnvironmentObjects() -> some View {
        environmentObject(BatteryStore.shared)
            .environmentObject(CpuStore.shared)
            .environmentObject(FanStore.shared)
            .environmentObject(MemoryStore.shared)
            .environmentObject(NetworkStore.shared)
            .environmentObject(PreferenceStore.shared)
    }
}
