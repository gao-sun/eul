//
//  PreferenceGeneralView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/12.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import LaunchAtLogin

extension Preference {
    struct GeneralView: View {
        @EnvironmentObject var preference: PreferenceStore
        var version: String? {
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        }

        var body: some View {
            HStack(spacing: 12) {
                version.map { ver in
                    Group {
                        Text("eul \("ui.version".localized()) \(ver)")
                            .inlineSection()
                    }
                }
                Button(action: {

                }) {
                    Text("ui.check_update".localized())
                }
                LaunchAtLogin.Toggle()
            }
            .padding(.vertical, 8)
        }
    }
}
