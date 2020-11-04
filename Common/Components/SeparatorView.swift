//
//  SeparatorView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct SeparatorView: View {
    var padding: CGFloat = 4

    var body: some View {
        Rectangle()
            .fill(Color.separator)
            .frame(height: 1)
            .padding(.vertical, padding)
    }
}
