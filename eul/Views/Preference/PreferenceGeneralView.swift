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

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 12) {
                    preference.version.map { ver in
                        Group {
                            Text("eul \("ui.version".localized()) \(ver)")
                                .inlineSection()
                        }
                    }
                    preference.repoURL.map { url in
                        Button(action: {
                            NSWorkspace.shared.open(url)
                        }) {
                            Text("GitHub")
                        }
                        .focusable(false)
                    }
                    HStack(spacing: 6) {
                        if preference.isUpdateAvailable == nil {
                            ActivityIndicatorView {
                                $0.style = .spinning
                                $0.controlSize = .small
                                $0.startAnimation(nil)
                            }
                            Text("ui.checking_update".localized())
                                .inlineSection()
                                .foregroundColor(.info)
                        } else if preference.checkUpdateFailed {
                        } else if preference.isUpdateAvailable == true {
                            preference.latestReleaseURL.map { url in
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
                self.preference.checkUpdate()
            }
        }
    }
}
