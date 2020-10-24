//
//  PreferenceStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Combine
import Foundation
import Localize_Swift
import SwiftyJSON

class PreferenceStore: ObservableObject {
    static let shared = PreferenceStore()
    static var availableLanguages: [String] {
        Localize.availableLanguages().filter { $0 != "Base" }
    }

    private let userDefaultsKey = "preference"
    private let repo = "gao-sun/eul"
    private var cancellable: AnyCancellable?

    var repoURL: URL? {
        URL(string: "https://github.com/\(repo)")
    }

    var latestReleaseURL: URL? {
        URL(string: "https://github.com/\(repo)/releases/latest")
    }

    var version: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
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
    @Published var fontDesign: Preference.FontDesign = .default
    @Published var smcRefreshRate = 3
    @Published var networkRefreshRate = 3
    @Published var showIcon = true
    @Published var showTopActivities = true
    @Published var isUpdateAvailable: Bool? = false
    @Published var checkUpdateFailed = true

    var json: JSON {
        JSON([
            "temperatureUnit": temperatureUnit.rawValue,
            "language": language,
            "textDisplay": textDisplay.rawValue,
            "fontDesign": fontDesign.rawValue,
            "smcRefreshRate": smcRefreshRate,
            "networkRefreshRate": networkRefreshRate,
            "showIcon": showIcon,
            "showTopActivities": showTopActivities,
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

    func checkUpdate() {
        isUpdateAvailable = nil
        checkUpdateFailed = false

        let session = URLSession.shared
        let url = URL(string: "https://api.github.com/repos/\(repo)/releases/latest")

        if let url = url {
            let task = session.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if
                        error == nil,
                        let version = self.version,
                        let tagName = JSON(data as Any)["tag_name"].string,
                        "v\(version)".compare(tagName, options: .numeric) == .orderedAscending
                    {
                        self.isUpdateAvailable = true
                    } else {
                        self.isUpdateAvailable = false
                    }
                }
            }
            task.resume()
        } else {
            isUpdateAvailable = false
            checkUpdateFailed = true
        }
    }

    func loadFromDefaults() {
        if let raw = UserDefaults.standard.data(forKey: userDefaultsKey) {
            do {
                let data = try JSON(data: raw)

                print("⚙️ loaded data from user defaults", userDefaultsKey, data)

                if let raw = data["temperatureUnit"].string, let value = TemperatureUnit(rawValue: raw) {
                    temperatureUnit = value
                }
                if let value = data["language"].string {
                    language = value
                }
                if let raw = data["textDisplay"].string, let value = Preference.TextDisplay(rawValue: raw) {
                    textDisplay = value
                }
                if let value = data["showIcon"].bool {
                    showIcon = value
                }
                if let raw = data["fontDesign"].string, let value = Preference.FontDesign(rawValue: raw) {
                    fontDesign = value
                }
                if let value = data["smcRefreshRate"].int {
                    smcRefreshRate = value
                }
                if let value = data["networkRefreshRate"].int {
                    networkRefreshRate = value
                }
                if let value = data["showTopActivities"].bool {
                    showTopActivities = value
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
