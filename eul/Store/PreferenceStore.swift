//
//  PreferenceStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import Localize_Swift

class PreferenceStore: ObservableObject {
    static let shared = PreferenceStore()
    static var availableLanguages: [String] {
        Localize.availableLanguages().filter { $0 != "Base" }
    }

    @Published var temperatureUnit = TemperatureUnit.celius {
        willSet {
            SmcControl.shared.tempUnit = newValue
        }
    }
    @Published var language = Localize.currentLanguage() {
        willSet {
            Localize.setCurrentLanguage(newValue)
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
