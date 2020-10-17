//
//  NetworkMenuBlockMenuView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct NetworkMenuBlockMenuView: View {
    @EnvironmentObject var networkStore: NetworkStore
    @EnvironmentObject var networkTopStore: NetworkTopStore

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text("network".localized())
                    .menuSection()
                Spacer()
                MiniSectionView(title: "network.in", value: networkStore.inSpeed)
                MiniSectionView(title: "network.out", value: networkStore.outSpeed)
            }
            if networkTopStore.processes.count > 0 {
                SeparatorView()
                VStack(spacing: 8) {
                    ForEach(networkTopStore.processes.prefix(5)) { process in
                        ProcessRowView(process: process, nameWidth: 130) { AnyView(
                            HStack(spacing: 4) {
                                Text(ByteUnit(process.value.inSpeedInByte).readable)
                                    .displayText()
                                Text(ByteUnit(process.value.outSpeedInByte).readable)
                                    .displayText()
                            }
                            .frame(width: 90, alignment: .trailing)
                        ) }
                    }
                }
            }
        }
        .menuBlock()
    }
}
