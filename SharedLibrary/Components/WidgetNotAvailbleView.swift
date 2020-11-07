//
//  WidgetNotAvailbleView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/6.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct WidgetNotAvailbleView: View {
    public init(text: String = "N/A") {
        self.text = text
    }

    public var text = "N/A"

    public var body: some View {
        Text(text)
            .inlineSection()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.controlBackground.opacity(0.98))
    }
}
