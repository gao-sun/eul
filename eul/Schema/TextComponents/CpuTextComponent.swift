//
//  CpuTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

enum CpuTextComponent: String, CaseIterable, JSONCodabble, LocalizedStringConvertible {
    case usage
    case temperature

    var localizedDescription: String {
        rawValue
    }
}
