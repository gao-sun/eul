//
//  GpuTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2021/1/24.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum GpuTextComponent: String, CaseIterable, JSONCodabble, LocalizedTextComponent {
    case usagePercentage
    case temperature

    static var defaultComponents: [Self] {
        [.usagePercentage]
    }
}
