//
//  StatusComponentConfigStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import SwiftyJSON

class StatusComponentConfigStore: ObservableObject {
    static let shared = StatusComponentConfigStore()
    private let userDefaultsKey = "statusComponentConfig"
    private var cancellable: AnyCancellable?

    @Published var configDict: [EulComponent: EulComponentConfig] = [:]

    var json: JSON {
        JSON([
            "configs": configDict.values.map { $0.json },
        ])
    }

    init() {
        loadFromDefaults()

        cancellable = objectWillChange.sink {
            DispatchQueue.main.async {
                self.saveToDefaults()
            }
        }
    }

    func loadFromDefaults() {
        if let raw = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let data = try JSON(data: raw)

                print("⚙️ loaded data from user defaults", userDefaultsKey, data)

                if let array = data["configs"].array {
                    configDict = array
                        .compactMap { EulComponentConfig($0) }
                        .reduce(into: [EulComponent: EulComponentConfig]()) {
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
            print("Unable to get preference data")
        }
    }
}
