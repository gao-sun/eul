//
//  Preference.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct Preference {
    enum TextDisplay: String, StringEnum {
        case compact
        case singleLine

        var description: String {
            switch self {
            case .compact:
                return "text_display.compact".localized()
            case .singleLine:
                return "text_display.single_line".localized()
            }
        }
    }

    enum FontDesign: String, StringEnum {
        case `default`
        case monospaced

        var value: Font.Design {
            switch self {
            case .default:
                return .default
            case .monospaced:
                return .monospaced
            }
        }

        var description: String {
            switch self {
            case .default:
                return "font_design.default".localized()
            case .monospaced:
                return "font_design.monospaced".localized()
            }
        }
    }
}
