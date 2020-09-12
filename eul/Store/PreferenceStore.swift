//
//  PreferenceStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class PreferenceStore: ObservableObject {
    static let shared = PreferenceStore()

    @Published var temperatureUnit = TemperatureUnit.celius {
        didSet {
            SmcControl.shared.tempUnit = temperatureUnit
        }
    }
    @Published var textDisplay = Preference.TextDisplay.compact
    @Published var isActiveComponentToggling = false
    @Published var activeComponents = EulComponent.allCases
    @Published var availableComponents: [EulComponent] = []

    func toggleActiveComponent(at index: Int) {
        isActiveComponentToggling = true
        availableComponents.append(activeComponents[index])
        activeComponents.remove(at: index)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // wait for rendering, will crash w/o delay
            self.isActiveComponentToggling = false
        }
    }

    func toggleAvailableComponent(at index: Int) {
        activeComponents.append(availableComponents[index])
        availableComponents.remove(at: index)
    }
}
