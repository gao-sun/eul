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

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> CpuEntry {
        Container.get(CpuEntry.self) ?? CpuEntry.sample
    }

    func getSnapshot(in context: Context, completion: @escaping (CpuEntry) -> Void) {
        if context.isPreview {
            completion(CpuEntry.sample)
        }

        let entry = Container.get(CpuEntry.self) ?? CpuEntry(isValid: false)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Container.get(CpuEntry.self) ?? CpuEntry(isValid: false)
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        let entries: [CpuEntry] = [entry, CpuEntry(date: nextDate, isValid: false)]

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
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
        .configurationDisplayName("widget.title".localized())
        .description("widget.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
