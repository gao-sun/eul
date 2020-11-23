//
//  DiskView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct DiskView: View {
    @EnvironmentObject var diskStore: DiskStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore

    var config: EulComponentConfig {
        componentConfigStore[.Disk]
    }

    var texts: [String] {
        [diskStore.freeString, diskStore.usageString]
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Disk")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if config.showText {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }
        }
    }
}
