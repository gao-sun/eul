//
//  SmcStruct.swift
//  eul
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct TemperatureSensor {
    public init(name: String, code: FourCharCode) {
        self.name = name
        self.code = code
    }

    public let name: String
    public let code: FourCharCode
}

public extension TemperatureUnit {
    init?(rawValue: String) {
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

public enum TemperatureUnit: String, Codable {
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

public extension Double {
    func formatTemp(unit: TemperatureUnit = .celius) -> String {
        String(format: "%.0f°\(unit.rawValue.prefix(1).uppercased())", self)
    }
}
