//
//  PreferenceGeneralView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/12.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import LaunchAtLogin
import SharedLibrary
import SwiftUI
import SwiftyJSON

extension Preference {
    struct GeneralView: View {
        @ObservedObject var launchAtLogin = LaunchAtLogin.observable
        @EnvironmentObject var preference: PreferenceStore

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 12) {
                    if let version = preference.version {
                        Text("eul \("ui.version".localized()) \(version)")
                            .inlineSection()
                            .fixedSize()
                    }
                    if let url = preference.repoURL {
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
                    .fixedSize()
                }
                Picker("ui.update_method".localized(), selection: $preference.updateMethod) {
                    ForEach(PreferenceStore.UpdateMethod.allCases, id: \.self) {
                        Text("ui.update_method.\($0)".localized())
                            .tag($0)
                    }
                }
                .fixedSize()
                Toggle(isOn: $launchAtLogin.isEnabled) {
                    Text("ui.launch_at_login".localized())
                        .inlineSection()
                }
                Toggle(isOn: $preference.checkStatusItemVisibility) {
                    Text("ui.check_status_item_visibility".localized())
                        .inlineSection()
                }
            }
            .padding(.vertical, 8)
        }
    }
}
