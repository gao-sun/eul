//
//  NetworkView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var networkStore: NetworkStore
    @EnvironmentObject var componentConfigStore: ComponentConfigStore
    @EnvironmentObject var textStore: ComponentsStore<NetworkTextComponent>

    var config: EulComponentConfig {
        componentConfigStore[.Network]
    }

    var texts: [String] {
        textStore.activeComponents.map {
            switch $0 {
            case .upload:
                return networkStore.outSpeed
            case .download:
                return networkStore.inSpeed
            }
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            if config.showIcon {
                Image("Network")
                    .resizable()
                    .frame(width: 13, height: 13)
            }
            if textStore.showComponents {
                StatusBarTextView(texts: texts)
                    .stableWidth(20, minWidth: 40)
            }
        }
    }
}
