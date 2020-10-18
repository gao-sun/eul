//
//  MenuActionTextView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/18.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct MenuActionTextView: View {
    let id: String
    let text: String
    var action: (() -> Void)?

    @EnvironmentObject var uiStore: UIStore

    var isOnHover: Bool {
        uiStore.hoveringID == id
    }

    var body: some View {
        Text(text.localized())
            .font(.system(size: 11, weight: .regular))
            .foregroundColor(isOnHover ? .primary : .secondary)
            .contentShape(Rectangle())
            .animation(.none)
            .onHover(perform: { hovering in
                if hovering {
                    uiStore.hoveringID = id
                } else if uiStore.hoveringID == id {
                    uiStore.hoveringID = nil
                }
            })
            .onTapGesture {
                action?()
            }
    }
}
