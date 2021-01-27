//
//  PreferenceStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import Combine
import Foundation
import Localize_Swift
import SharedLibrary
import SwiftyJSON
import WidgetKit

class PreferenceStore: ObservableObject {
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
    @Published var showCPUTopActivities = true
    @Published var showRAMTopActivities = false
    @Published var showNetworkTopActivities = false
    @Published var cpuMenuDisplay: Preference.CpuMenuDisplay = .usagePercentage
    @Published var checkStatusItemVisibility = true
    @Published var isUpdateAvailable: Bool? = false
    @Published var checkUpdateFailed = true
    @Published var appearanceMode = Preference.appearance.auto

    var json: JSON {
        JSON([
            "temperatureUnit": temperatureUnit.rawValue,
            "language": language,
            "textDisplay": textDisplay.rawValue,
            "fontDesign": fontDesign.rawValue,
            "smcRefreshRate": smcRefreshRate,
            "networkRefreshRate": networkRefreshRate,
            "showIcon": showIcon,
            "showCPUTopActivities": showCPUTopActivities,
            "showRAMTopActivities": showRAMTopActivities,
            "showNetworkTopActivities": showNetworkTopActivities,
            "cpuMenuDisplay": cpuMenuDisplay.rawValue,
            "checkStatusItemVisibility": checkStatusItemVisibility,
            "appearance": appearanceMode.rawValue,
        ])
    }

    init() {
        loadFromDefaults()
        writeToContainer()

        cancellable = objectWillChange.sink {
            DispatchQueue.main.async {
                self.saveToDefaults()
                self.writeToContainer()
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
                if let value = data["showCPUTopActivities"].bool {
                    showCPUTopActivities = value
                }
                if let value = data["showRAMTopActivities"].bool {
                    showRAMTopActivities = value
                }
                if let value = data["showNetworkTopActivities"].bool {
                    showNetworkTopActivities = value
                }
                if let raw = data["cpuMenuDisplay"].string, let value = Preference.CpuMenuDisplay(rawValue: raw) {
                    cpuMenuDisplay = value
                }
                if let value = data["checkStatusItemVisibility"].bool {
                    checkStatusItemVisibility = value
                }
                if let raw = data["appearance"].string, let value = Preference.appearance(rawValue: raw) {
                    appearanceMode = value
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

    func writeToContainer() {
        Container.set(PreferenceEntry(temperatureUnit: temperatureUnit))
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func changeColorScheme() {
        let window = NSApplication.shared.mainWindow
        if appearanceMode == .light {
            let appearence = NSAppearance(named: .aqua)
            window?.appearance = appearence
            StatusBarManager.shared.changeNSWindowColorScheme(to: .aqua)

        } else if appearanceMode == .dark {
            let appearence = NSAppearance(named: .darkAqua)
            window?.appearance = appearence
            StatusBarManager.shared.changeNSWindowColorScheme(to: .darkAqua)

        } else {
            window?.appearance = nil
            StatusBarManager.shared.changeNSWindowColorScheme(to: nil)
        }
    }
}
