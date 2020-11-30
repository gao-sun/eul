//
//  CpuTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum CpuTextComponent: String, CaseIterable, JSONCodabble, LocalizedTextComponent {
    case usagePercentage
    case temperature
    case loadAverage1Min
    case loadAverage5Min
    case loadAverage15Min

    static var defaultComponents: [Self] {
        [.usagePercentage, .temperature]
    }
}
