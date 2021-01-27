//
//  NetworkMenuBlockMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct NetworkMenuBlockMenuView: View {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var networkStore: NetworkStore
    @EnvironmentObject var networkTopStore: NetworkTopStore

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("network".localized())
                    .menuSection()
                Spacer()
                MiniSectionView(title: "network.out", value: networkStore.outSpeed)
                    .frame(width: 60, alignment: .leading)
                MiniSectionView(title: "network.in", value: networkStore.inSpeed)
                    .frame(width: 60, alignment: .leading)
            }
            if preferenceStore.showNetworkTopActivities {
                SeparatorView()
                // FIXME: multi thread with same pid
                VStack(spacing: 8) {
                    ForEach(networkTopStore.processes.prefix(3)) { process in
                        ProcessRowView(section: "network", process: process, nameWidth: 140) { AnyView(
                            HStack(spacing: 4) {
                                Text(ByteUnit(process.value.outSpeedInByte).readable)
                                    .displayText()
                                Text(ByteUnit(process.value.inSpeedInByte).readable)
                                    .displayText()
                            }
                            .frame(width: 90, alignment: .trailing)
                        ) }
                    }
                    if networkTopStore.processes.count == 0 {
                        Spacer()
                        Text("network.no_activity".localized())
                            .secondaryDisplayText()
                        Spacer()
                    }
                }
                .frame(height: 58, alignment: .top)
            }
        }
        .menuBlock()
    }
}
