//
//  BatteryWidget.swift
//  BatteryWidget
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Intents
import Localize_Swift
import SharedLibrary
import SwiftUI
import WidgetKit

extension BatteryEntry.BatteryCondition {
    var description: String {
        "battery.condition.\(rawValue)".localized()
    }
}

extension BatteryEntry.PowerSourceState {
    var description: String {
        "battery.power_source.\(rawValue)".localized()
    }
}

struct Provider: StandardProvider {
    typealias WidgetEntry = BatteryEntry
}

struct BatteryWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                HStack(alignment: .top) {
                    BatteryIconView(
                        size: 16,
                        isCharging: entry.isCharging,
                        charge: entry.charge ?? 1,
                        acPowered: entry.acPowered
                    )
                    Spacer()
                }
                HStack {
                    Text(entry.chargeString)
                        .widgetTitle()
                    Spacer()
                }
                .padding(.bottom, 24)
                if entry.isValid {
                    HStack {
                        Group {
                            WidgetSectionView(title: "battery.health".localized(), value: entry.health.percentageString)
                            WidgetSectionView(title: "battery.cycle".localized(), value: entry.cycleCount.description)
                            WidgetSectionView(title: "battery.condition".localized(), value: entry.condition.description)
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
struct BatteryWidget: Widget {
    let kind: String = BatteryEntry.kind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BatteryWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("widget.battery.title".localized())
        .description("widget.battery.description".localized())
        .supportedFamilies([.systemSmall])
    }
}
