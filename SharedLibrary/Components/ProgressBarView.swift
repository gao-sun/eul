//
//  ProgressBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct ProgressBarView: View {
    public init(width: CGFloat = 80, percentage: CGFloat = 100, showText: Bool = true, textWidth: CGFloat = 40, customText: String? = nil) {
        self.width = width
        self.percentage = percentage
        self.showText = showText
        self.textWidth = textWidth
        self.customText = customText
    }

    @State var firstAppear = true
    public var width: CGFloat = 80
    public var percentage: CGFloat = 100
    public var showText = true
    public var textWidth: CGFloat = 40
    public var customText: String?

    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: width, height: 4)
                    .foregroundColor(.controlBackground)
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: width * percentage / 100, height: 4)
                    .foregroundColor(.primary)
            }
            if showText {
                Text(customText.map { $0 } ?? String(format: "%.1f%%", percentage))
                    .displayText()
                    .frame(width: textWidth, alignment: .trailing)
            }
        }
        .onAppear {
            self.firstAppear = false
        }
    }
}
