//
//  MemoryWidget.swift
//  MemoryWidget
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
    typealias WidgetEntry = MemoryEntry
}

struct MemoryWidgetEntryView: View {
    var preferenceEntry = Container.get(PreferenceEntry.self) ?? PreferenceEntry()
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                HStack(alignment: .top) {
                    Image("Memory")
                        .resizable()
                        .frame(width: 12, height: 12)
                    Spacer()
                    if let temp = entry.temp {
                        Text(temp.formatTemp(unit: preferenceEntry.temperatureUnit))
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                HStack {
                    Text(entry.usageString)
                        .widgetTitle()
                    Spacer()
                }
                .padding(.bottom, 24)
                if entry.isValid {
                    HStack {
                        Group {
                            WidgetSectionView(title: "memory.usage".localized(), value: entry.used.memoryString)
                            WidgetSectionView(title: "memory.free".localized(), value: (entry.total - entry.used).memoryString)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
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
struct MemoryWidget: Widget {
    let kind: String = MemoryEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MemoryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.memory.title".localized())
        .description("widget.memory.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
