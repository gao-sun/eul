//
//  CpuWidget.swift
//  CpuWidget
//
//  Created by Gao Sun on 2020/11/4.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Intents
import Localize_Swift
import SharedLibrary
import SwiftUI
import WidgetKit

struct Provider: StandardProvider {
    typealias WidgetEntry = CpuEntry
}

struct CpuWidgetEntryView: View {
    var preferenceEntry = Container.get(PreferenceEntry.self) ?? PreferenceEntry()
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                HStack(alignment: .top) {
                    Image("CPU")
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
                HStack {
                    Group {
                        if let usageSystem = entry.usageSystem {
                            WidgetSectionView(title: "cpu.system".localized(), value: String(format: "%.1f%%", usageSystem))
                        }
                        if let usageUser = entry.usageUser {
                            WidgetSectionView(title: "cpu.user".localized(), value: String(format: "%.1f%%", usageUser))
                        }
                        if let usageNice = entry.usageNice {
                            WidgetSectionView(title: "cpu.nice".localized(), value: String(format: "%.1f%%", usageNice))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
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
struct CpuWidget: Widget {
    let kind: String = CpuEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CpuWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.cpu.title".localized())
        .description("widget.cpu.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
