//
//  MemoryTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum MemoryTextComponent: String, CaseIterable, JSONCodabble, LocalizedTextComponent {
    case free
    case usage
    case total
    case usagePercentage
    case temperature

    static var defaultComponents: [Self] {
        [.free, .usage]
    }
}
