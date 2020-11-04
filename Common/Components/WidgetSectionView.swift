//
//  WidgetSectionView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/4.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct WidgetSectionView: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title.localized())
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.thirdary)
            Text(value)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
        }
    }
}
