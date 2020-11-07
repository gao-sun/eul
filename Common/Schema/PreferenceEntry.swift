//
//  PreferenceEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct PreferenceEntry: SharedEntry {
    static let containerKey = "PreferenceEntry"

    var temperatureUnit = TemperatureUnit.celius
}
