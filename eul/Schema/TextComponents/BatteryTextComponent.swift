//
//  BatteryTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum BatteryTextComponent: String, CaseIterable, JSONCodabble, LocalizedStringConvertible {
    case percentage
    case mah

    var localizedDescription: String {
        rawValue
    }

    static var defaultComponents: [Self] {
        [.percentage]
    }
}
