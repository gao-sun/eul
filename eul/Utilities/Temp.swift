//
//  Temp.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

enum TemperatureUnit {
    case celius
    case fahrenheit
    case kelvin

    public static func toFahrenheit(_ celius: Double) -> Double {
        // https://en.wikipedia.org/wiki/Fahrenheit#Definition_and_conversions
        return (celius * 1.8) + 32
    }

    public static func toKelvin(_ celius: Double) -> Double {
        // https://en.wikipedia.org/wiki/Kelvin
        return celius + 273.15
    }
}

extension TemperatureUnit: RawRepresentable {
    var description: String {
        switch self {
        case .celius:
            return "temp.celsius".localized()
        case .fahrenheit:
            return "temp.fahrenheit".localized()
        case .kelvin:
            return "temp.kelvin".localized()
        }
    }

    public var rawValue: String {
        switch self {
        case .celius:
            return "celsius"
        case .fahrenheit:
            return "fahrenheit"
        case .kelvin:
            return "kelvin"
        }
    }

    public init?(rawValue: String) {
        let lowercased = rawValue.lowercased()

        if lowercased == "celius" || lowercased == "celsius" || lowercased == "c" {
            self = .celius
            return
        }
        if lowercased == "fahrenheit" || lowercased == "f" {
            self = .fahrenheit
            return
        }
        if lowercased == "kelvin" || lowercased == "k" {
            self = .kelvin
            return
        }
        return nil
    }
}
