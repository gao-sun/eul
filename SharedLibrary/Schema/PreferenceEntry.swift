//
//  PreferenceEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct PreferenceEntry: SharedEntry {
    public init(temperatureUnit: TemperatureUnit = TemperatureUnit.celius) {
        self.temperatureUnit = temperatureUnit
    }

    public static let containerKey = "PreferenceEntry"

    public var temperatureUnit = TemperatureUnit.celius
}
