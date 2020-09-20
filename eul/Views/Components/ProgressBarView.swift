//
//  ProgressBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    @State var firstAppear = true
    var width: CGFloat = 80
    var percentage: CGFloat = 100
    var showText = true
    var textWidth: CGFloat = 40
    var customText: String? = nil

    var body: some View {
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
        .animation(firstAppear ? .none : .fast)
        .onAppear {
            self.firstAppear = false
        }
    }
}
