//
//  CpuWidget.swift
//  CpuWidget
//
//  Created by Gao Sun on 2020/11/4.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Intents
import Localize_Swift
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct CpuWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            HStack(alignment: .top) {
                Image("CPU")
                    .resizable()
                    .frame(width: 12, height: 12)
                Spacer()
                Text("79°C")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("48%")
                    .widgetTitle()
                Spacer()
            }
            .padding(.bottom, 24)
            HStack {
                WidgetSectionView(title: "cpu.system", value: String(format: "%.1f%%", 41.1))
                Spacer()
                WidgetSectionView(title: "cpu.user", value: String(format: "%.1f%%", 32.2))
                Spacer()
                WidgetSectionView(title: "cpu.nice", value: String(format: "%.1f%%", 15.8))
            }
            Spacer()
        }
        .padding(16)
    }
}

@main
struct CpuWidget: Widget {
    let kind: String = "CpuWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CpuWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.title".localized())
        .description("widget.description".localized())
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
