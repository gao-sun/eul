//
//  PreferenceComponentConfigView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Localize_Swift
import SharedLibrary
import SwiftUI

extension Preference {
    struct ComponentConfigView: View {
        @EnvironmentObject var componentConfigStore: ComponentConfigStore

        var component: EulComponent
        var config: Binding<EulComponentConfig> {
            $componentConfigStore[component]
        }

        var body: some View {
            SectionView(title: component.localizedDescription) {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: config.showIcon) {
                        Text("ui.show_icon".localized())
                            .inlineSection()
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
