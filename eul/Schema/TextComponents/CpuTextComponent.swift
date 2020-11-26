//
//  CpuTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum CpuTextComponent: String, CaseIterable, JSONCodabble, LocalizedStringConvertible {
    case usagePercentage
    case temperature

    var localizedDescription: String {
        rawValue
    }
}
