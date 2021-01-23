//
//  RamProcessRowView.swift
//  eul
//
//  Created by Jevon Mao on 1/18/21.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct RamProcessRowView: View {
    let section: String
    let process: RamUsage
    var nameWidth: CGFloat = 200
    var valueViewBuilder: (() -> AnyView)? = nil

    func doubleToStringSingleDigit(for number: Double) -> String {
        return String(format: "%.1f", number)
    }

    var body: some View {
        HStack {
            Text(process.displayName)
                .secondaryDisplayText()
                .frame(width: nameWidth, alignment: .leading)
                .lineLimit(1)
            Spacer()
            if let builder = valueViewBuilder {
                builder()
            } else {
                let percentage = process.percentage

                HStack {
                    Text("\(ByteUnit(process.usageAmount).readable)")
                        .displayText()
                        .frame(alignment: .trailing)
                    Text(doubleToStringSingleDigit(for: percentage))
                        .displayText()
                        .frame(width: 35, alignment: .trailing)
                }
            }
            RamProcessComponentView(process: process, section: section)
        }
    }
}
