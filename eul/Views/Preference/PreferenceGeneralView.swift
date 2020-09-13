//
//  PreferenceGeneralView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/12.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import LaunchAtLogin
import SwiftyJSON

extension Preference {
    struct GeneralView: View {
        @ObservedObject var launchAtLogin = LaunchAtLogin.observable
        @EnvironmentObject var preference: PreferenceStore
        @State var isUpdateAvailable: Bool?
        @State var checkUpdateFailed = false

        let repo = "gao-sun/eul"

        var version: String? {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }

        func checkUpdate() {
            isUpdateAvailable = nil
            checkUpdateFailed = false

            let session = URLSession.shared
            let url = URL(string: "https://api.github.com/repos/\(repo)/releases/latest")

            if let url = url {
                let task = session.dataTask(with: url) { data, response, error in
                    if
                        error == nil,
                        let version = self.version,
                        let tagName = JSON(data as Any)["tag_name"].string,
                        version.compare(tagName, options: .numeric) == .orderedAscending
                    {
                        self.isUpdateAvailable = true
                    } else {
                        self.isUpdateAvailable = false
                    }
                }
                task.resume()
            } else {
                self.isUpdateAvailable = false
                self.checkUpdateFailed = true
            }
        }

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 12) {
                    version.map { ver in
                        Group {
                            Text("eul \("ui.version".localized()) \(ver)")
                                .inlineSection()
                        }
                    }
                    URL(string: "https://github.com/\(repo)").map { url in
                        Button(action: {
                            NSWorkspace.shared.open(url)
                        }) {
                            Text("GitHub")
                        }
                        .focusable(false)
                    }
                    HStack(spacing: 6) {
                        if isUpdateAvailable == nil {
                            ActivityIndicatorView {
                                $0.style = .spinning
                                $0.controlSize = .small
                                $0.startAnimation(nil)
                            }
                            Text("ui.checking_update".localized())
                                .inlineSection()
                                .foregroundColor(.info)
                        } else if checkUpdateFailed {
                        } else if isUpdateAvailable == true {
                            URL(string: "https://github.com/\(repo)/releases/latest").map { url in
                                Button(action: {
                                    NSWorkspace.shared.open(url)
                                }) {
                                    Text("ui.download".localized())
                                }
                                .focusable(false)
                            }
                            Text("ui.new_version".localized())
                                .inlineSection()
                                .foregroundColor(.info)
                        } else {
                            Text("ui.up_to_date".localized())
                                .inlineSection()
                                .foregroundColor(.info)
                        }
                    }
                }
                Toggle(isOn: $launchAtLogin.isEnabled) {
                    Text("ui.launch_at_login".localized())
                        .inlineSection()
                }
            }
            .padding(.vertical, 8)
            .onAppear {
                self.checkUpdate()
            }
        }
    }
}
