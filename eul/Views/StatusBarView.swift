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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadStatusBar()
        }
    }

    var body: some View {
        HStack {
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
