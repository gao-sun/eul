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

    @Published var language = Localize.currentLanguage() {
        willSet {
            Localize.setCurrentLanguage(newValue)
        }
    }

    @Published var textDisplay = Preference.TextDisplay.compact
    @Published var isActiveComponentToggling = false
    @Published var activeComponents = EulComponent.allCases
    @Published var availableComponents: [EulComponent] = []
    @Published var fontDesign: Preference.FontDesign = .default
    @Published var networkRefreshRate = 3
    @Published var showComponents = true
    @Published var showIcon = true
    @Published var showTopActivities = false
    @Published var isUpdateAvailable: Bool? = false
    @Published var checkUpdateFailed = true

    var json: JSON {
        JSON([
            "language": language,
            "textDisplay": textDisplay.rawValue,
            "activeComponents": activeComponents.map { $0.rawValue },
            "availableComponents": availableComponents.map { $0.rawValue },
            "fontDesign": fontDesign.rawValue,
            "networkRefreshRate": networkRefreshRate,
            "showComponents": showComponents,
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

                print("⚙️ loaded data from user defaults", data)

                if let value = data["language"].string {
                    language = value
                }
                if let raw = data["textDisplay"].string, let value = Preference.TextDisplay(rawValue: raw) {
                    textDisplay = value
                }
                if let array = data["activeComponents"].array {
                    activeComponents = array.compactMap {
                        if let string = $0.string {
                            return EulComponent(rawValue: string)
                        }
                        return nil
                    }
                }
                if let array = data["availableComponents"].array {
                    availableComponents = array.compactMap {
                        if let string = $0.string {
                            return EulComponent(rawValue: string)
                        }
                        return nil
                    }
                }
                if let value = data["showComponents"].bool {
                    showComponents = value
                }
                if let value = data["showIcon"].bool {
                    showIcon = value
                }
                if let raw = data["fontDesign"].string, let value = Preference.FontDesign(rawValue: raw) {
                    fontDesign = value
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
