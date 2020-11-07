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

    var isValid: Bool { get }
}
