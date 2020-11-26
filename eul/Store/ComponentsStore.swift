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

class ComponentsStore<Component: JSONCodabble & Equatable>: ObservableObject {
    @Published var showComponents = true
    @Published var isActiveComponentToggling = false
    @Published var activeComponents: [Component]
    @Published var availableComponents: [Component]

    private let allComponents: [Component]
    private let userDefaultsKey: String
    private var cancellable: AnyCancellable?

    var totalCount: Int {
        allComponents.count
    }

    var json: JSON {
        JSON([
            "showComponents": showComponents,
            "activeComponents": activeComponents.map { $0.json },
            "availableComponents": availableComponents.map { $0.json },
        ])
    }

    init(key: String = String(describing: Component.self), allComponents all: [Component]) {
        allComponents = all
        userDefaultsKey = key
        activeComponents = allComponents
        availableComponents = []
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
                        Component(json: $0)
                    }
                }
                if let array = data["availableComponents"].array {
                    availableComponents = array.compactMap {
                        Component(json: $0)
                    }
                    availableComponents += allComponents.filter {
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

extension ComponentsStore where Component: CaseIterable {
    convenience init(key: String = String(describing: Component.self)) {
        self.init(key: key, allComponents: Array(Component.allCases))
    }
}
