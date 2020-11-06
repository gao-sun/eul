//
//  WidgetNotAvailbleView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/6.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct WidgetNotAvailbleView: View {
    var body: some View {
        Text("widget.not_available".localized())
            .inlineSection()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.controlBackground.opacity(0.98))
    }
}
