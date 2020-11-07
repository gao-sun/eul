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

    var isValid: Bool { get }

    init(date: Date, isValid: Bool)
    init(isValid: Bool)
}

public extension SharedWidgetEntry {
    init(isValid: Bool) {
        self.init(date: Date(), isValid: isValid)
    }
}
