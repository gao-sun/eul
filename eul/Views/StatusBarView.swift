//
//  StatusBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusBarView: View {
    static var statusBarHeight: CGFloat {
        NSStatusBar.system.thickness
    }
    let cpu = CPUStatus()
    @State var usage = ""
    @State var temp = ""

    func loadStatusBar() {
        usage = cpu.usage
        temp = cpu.temp
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loadStatusBar()
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Image("Arrows")
                .resizable()
                .frame(width: 15, height: 15)
            VStack(alignment: .leading, spacing: 0) {
                Text("148Kb/s")
                    .compact()
                Text("1.3Mb/s")
                    .compact()
            }
            Image("CPU")
                .resizable()
                .frame(width: 15, height: 15)
            VStack(alignment: .leading, spacing: 0) {
                Text(usage)
                    .compact()
                Text(temp)
                    .compact()
            }
        }
        .onAppear {
            self.loadStatusBar()
        }
    }
}
