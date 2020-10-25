//
//  ComponentsStore.swift
//  eul
//
//  Created by Gao Sun on 2020/10/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import SwiftyJSON

class ComponentsStore<Component: CaseIterable & RawRepresentable & Equatable>: ObservableObject where Component.RawValue == String {
    @Published var showComponents = true
    @Published var isActiveComponentToggling = false
    @Published var activeComponents = Array(Component.allCases)
    @Published var availableComponents: [Component] = []

    private let userDefaultsKey: String
    private var cancellable: AnyCancellable?

    var json: JSON {
        JSON([
            "showComponents": showComponents,
            "activeComponents": activeComponents.map { $0.rawValue },
            "availableComponents": availableComponents.map { $0.rawValue },
        ])
    }

    init(key: String) {
        userDefaultsKey = key
        loadFromDefaults()
        cancellable = objectWillChange.sink {
            DispatchQueue.main.async {
                self.saveToDefaults()
            }
        }
    }

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

    func loadFromDefaults() {
        if let raw = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let data = try JSON(data: raw)

                print("⚙️ loaded data from user defaults", userDefaultsKey, data)

                if let value = data["showComponents"].bool {
                    showComponents = value
                }

                if let array = data["activeComponents"].array {
                    activeComponents = array.compactMap {
                        if let string = $0.string {
                            return Component(rawValue: string)
                        }
                        return nil
                    }
                }
                if let array = data["availableComponents"].array {
                    availableComponents = array.compactMap {
                        if let string = $0.string {
                            return Component(rawValue: string)
                        }
                        return nil
                    }
                    availableComponents += Array(Component.allCases).filter {
                        !activeComponents.contains($0) && !availableComponents.contains($0)
                    }
                }
            } catch {
                print("Unable to get preference data from user defaults")
            }
        }
    }

    func saveToDefaults() {
        do {
            let data = try json.rawData()
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Unable to get preference data")
        }
    }
}

let sharedComponentsStore = ComponentsStore<EulComponent>(key: "components")
let sharedMenuComponentsStore = ComponentsStore<EulMenuComponent>(key: "menuComponents")
