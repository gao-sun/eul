//
//  SharedWidgetEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import WidgetKit

public protocol SharedWidgetEntry: SharedEntry, TimelineEntry {
    static var kind: String { get }
    static var sample: Self { get }

    var outdated: Bool { get }
    var isValid: Bool { get }

    init(date: Date, outdated: Bool)
    init(outdated: Bool)
}

public extension SharedWidgetEntry {
    init(outdated: Bool) {
        self.init(date: Date(), outdated: outdated)
    }

    var isValid: Bool {
        !outdated && date.timeIntervalSinceNow >= -3
    }
}
