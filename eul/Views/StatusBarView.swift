//
//  StatusBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusBarView: View {
    static var height: CGFloat {
        NSStatusBar.system.thickness
    }

    func refreshRepeatedly() {
        NotificationCenter.default.post(name: .SMCShouldRefresh, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshRepeatedly()
        }
    }

    var body: some View {
        HStack {
            CpuView()
            FanView()
            MemoryView()
            BatteryView()
        }
        .environmentObject(CpuStore.shared)
        .environmentObject(FanStore.shared)
        .environmentObject(MemoryStore.shared)
        .environmentObject(BatteryStore.shared)
        .environmentObject(NetworkStore.shared)
        .onAppear {
            SmcControl.shared.start()
            self.refreshRepeatedly()
        }
    }
}
