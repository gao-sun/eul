//
//  MenuInfoView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI

struct MenuInfoView: View {
    var label: String?
    var text: String

    var body: some View {
        HStack(spacing: 4) {
            if let label = label {
                Text(label)
                    .miniSection()
            }
            Text(text)
                .displayText()
        }
    }
}
