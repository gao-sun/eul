//
//  StandardProvider.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import WidgetKit

@available(OSXApplicationExtension 11, *)
public protocol StandardProvider: TimelineProvider {
    associatedtype WidgetEntry: SharedWidgetEntry
}

@available(OSXApplicationExtension 11, *)
public extension StandardProvider {
    func placeholder(in _: Context) -> WidgetEntry {
        Container.get(WidgetEntry.self) ?? WidgetEntry.sample
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> Void) {
        if context.isPreview {
            completion(WidgetEntry.sample)
            return
        }

        let entry = Container.get(WidgetEntry.self) ?? WidgetEntry(outdated: true)
        completion(entry)
    }

    func getTimeline(in _: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        let entry = Container.get(WidgetEntry.self) ?? WidgetEntry(outdated: true)
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        let entries: [WidgetEntry] = [entry, WidgetEntry(date: nextDate, outdated: true)]

        let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(10)))
        completion(timeline)
    }
}
