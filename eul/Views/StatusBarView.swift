//
//  StatusBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SystemKit

var system = System()

struct StatusBarView: View {
    static var statusBarHeight: CGFloat {
        NSStatusBar.system.thickness
    }
    @State var usage = ""
    @State var temp = ""

    func loadStatusBar() {
        do {
            try SMCKit.open()
            let temps = try SMCKit.allKnownTemperatureSensors()
            try temps.forEach {
                try print("!!!", $0.name, $0.code, SMCKit.temperature($0.code))
            }
            let fans = try SMCKit.fanCount()
            print("??? count", fans)
            let cpu = system.usageCPU()
            print(cpu.system, cpu.user, cpu.idle, cpu.nice)
            self.usage = String(format: "%.1f%%", cpu.system + cpu.user)
//            try fans.forEach {
//                try print("???", $0.name, $0.minSpeed, $0.maxSpeed, SMCKit.fanCurrentSpeed($0.id))
//            }
        } catch SMCKit.SMCError.keyNotFound {
            print("SMCKey to read the current fan speed was not found")
        } catch SMCKit.SMCError.notPrivileged {
            print("Not privileged to read the current fan speed")
        } catch let error {
            print("error", error)
        }
        SMCKit.close()
//        usage = cpu.usage
//        temp = cpu.temp
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
            // will have fake info first time
            _ = system.usageCPU()
            // TODO: delay usage loading
            self.loadStatusBar()
        }
    }
}
