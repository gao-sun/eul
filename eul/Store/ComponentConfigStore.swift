//
//  ComponentConfigStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import SwiftyJSON

class ComponentConfigStore: ObservableObject {
    static func makeConfigDict() -> Dict<EulComponent, EulComponentConfig> {
        Dict<EulComponent, EulComponentConfig>(buildDefault: {
            EulComponentConfig(component: $0)
        })
    }

    subscript(_ key: EulComponent) -> EulComponentConfig {
        get {
            configDict[key]
        }

        set {
            configDict[key] = newValue
        }
    }

    private let userDefaultsKey = "componentConfig"
    private var cancellable: AnyCancellable?
    private var converted = false
    private var onDidChange: (() -> Void)?

    @Published var configDict = ComponentConfigStore.makeConfigDict()

    var json: JSON {
        JSON([
            "converted": converted,
            "configs": configDict.dict.values.map { $0.json },
        ])
    }

    init(onDidChange didChange: (() -> Void)?) {
        onDidChange = didChange

        loadFromDefaults()
        convertIfNeeded()

        cancellable = objectWillChange.sink {
            DispatchQueue.main.async { [self] in
                saveToDefaults()
                onDidChange?()
            }
        }
    }

    func convertIfNeeded() {
        guard !converted else {
            return
        }

        let value = SharedStore.preference.showIcon
        EulComponent.allCases.forEach {
            configDict[$0].showIcon = value
        }

        converted = true
        saveToDefaults()
    }

    func loadFromDefaults() {
        if let raw = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let data = try JSON(data: raw)

                print("⚙️ loaded data from user defaults", userDefaultsKey, data)

                if let bool = data["converted"].bool {
                    converted = bool
                }

                if let array = data["configs"].array {
                    configDict = array
                        .compactMap { EulComponentConfig($0) }
                        .reduce(into: ComponentConfigStore.makeConfigDict()) {
                            $0[$1.component] = $1
                        }
                }
            } catch {
                print("Unable to get status component config data from user defaults")
            }
        }
    }

    func saveToDefaults() {
        do {
            let data = try json.rawData()
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Unable save status component config")
        }
    }
}
