//
//  PreferenceComponentsView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct ComponentsView: View {
        private let coordinateSpace = "ComponentsOrdering"
        @EnvironmentObject var componentsStore: ComponentsStore<EulComponent>

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Toggle(isOn: $componentsStore.showComponents) {
                        Text("ui.show_components_in_status_bar".localized())
                            .inlineSection()
                    }
                    Spacer()
                }
                if componentsStore.showComponents {
                    HorizontalOrganizingView(
                        componentsStore: componentsStore,
                        count: EulComponent.allCases.count,
                        coordinateSpace: coordinateSpace
                    ) { component in
                        HStack {
                            Image(component.rawValue)
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(component.localizedDescription)
                                .normal()
                        }
                    }
                }
            }
        }
    }
}
