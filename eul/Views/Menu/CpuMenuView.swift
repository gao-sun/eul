//
//  CpuMenu.swift
//  eul
//
//  Created by Gao Sun on 2020/8/23.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct CpuMenuView: SizeChangeView {
    var onSizeChange: ((CGSize) -> Void)?
    @ObservedObject var cpuStore = CpuStore.shared

    var usage: Double {
        guard let usageCPU = cpuStore.usageCPU else {
            return 0
        }
        return usageCPU.system + usageCPU.user
    }

    var body: some View {
        VStack {
            HStack {
                Text("Usage")
                Spacer()
                Text(String(format: "%.1f%%", usage))
            }
            HStack {
                Text("Idle")
                Spacer()
                Text(String(format: "%.1f%%", 100 - usage))
            }
        }
        .frame(width: 120)
        .padding(.leading, 20)
        .fixedSize()
        .background(GeometryReader { self.reportSize($0) })
    }
}
