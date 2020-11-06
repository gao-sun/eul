//
//  SharedEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import WidgetKit

protocol SharedEntry: TimelineEntry, Codable {
    static var containerKey: String { get }

    var isValid: Bool { get }
}
