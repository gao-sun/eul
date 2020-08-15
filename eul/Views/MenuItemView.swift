//
//  MenuItemView.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

enum MenuItem: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    static var components: [MenuItem] {
        allCases.filter { $0 != .General }
    }

    case General
    case CPU
    case Fan
    case Memory
    case Battery
    case Network
}

struct MenuItemView: View {
    var item: MenuItem
    var active = false

    var body: some View {
        HStack(spacing: 8) {
            Image(item.rawValue)
                .resizable()
                .frame(width: 16, height: 16)
            Text(item.rawValue)
                .font(.body)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .background(active ? Color.selectedBackground : Color.clear)
        .contentShape(Rectangle())
    }
}
