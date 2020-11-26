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
    @EnvironmentObject var textStore: ComponentsStore<DiskTextComponent>

    var config: EulComponentConfig {
        componentConfigStore[.Disk]
    }

    var texts: [String] {
        textStore.activeComponents.map {
            switch $0 {
            case .free:
                return diskStore.freeString
            case .usage:
                return diskStore.usageString
            case .total:
                return diskStore.totalString
            case .usagePercentage:
                return diskStore.usagePercentageString
            }
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Disk")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if textStore.showComponents {
                StatusBarTextView(texts: texts)
                    .stableWidth()
            }
        }
    }
}
