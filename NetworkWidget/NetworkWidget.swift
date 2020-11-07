//
//  NetworkWidget.swift
//  NetworkWidget
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Intents
import Localize_Swift
import SharedLibrary
import SwiftUI
import WidgetKit

struct Provider: StandardProvider {
    typealias WidgetEntry = NetworkEntry
}

struct NetworkWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 4) {
                Spacer()
                HStack(spacing: 4) {
                    Image("Up")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("network.out".localized())
                        .font(.system(size: 12, weight: .semibold))
                        .fixedSize()
                    Spacer()
                }
                .foregroundColor(Color.secondary)
                Text(ByteUnit(entry.outSpeedInByte).readable + "/s")
                    .widgetDisplayText()
                    .padding(.bottom, 12)
                HStack(spacing: 4) {
                    Image("Down")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Text("network.in".localized())
                        .font(.system(size: 12, weight: .semibold))
                        .fixedSize()
                    Spacer()
                }
                .foregroundColor(Color.secondary)
                Text(ByteUnit(entry.inSpeedInByte).readable + "/s")
                    .widgetDisplayText()
                Spacer()
            }
            .padding(16)
            if !entry.isValid {
                WidgetNotAvailbleView(text: "widget.not_available".localized())
            }
        }
    }
}

@main
struct NetworkWidget: Widget {
    let kind: String = NetworkEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NetworkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.network.title".localized())
        .description("widget.network.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
