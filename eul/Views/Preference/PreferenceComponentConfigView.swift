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
    struct ComponentTextConfigView<Component: Equatable & JSONCodabble & Hashable & LocalizedStringConvertible>: View {
        @EnvironmentObject var componentsStore: ComponentsStore<Component>

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Toggle(isOn: $componentsStore.showComponents) {
                        Text("component.show_text".localized())
                            .inlineSection()
                    }
                    Spacer()
                }
                HorizontalOrganizingView(componentsStore: componentsStore) { component in
                    HStack {
                        Text(component.localizedDescription)
                            .normal()
                    }
                }
            }
        }
    }

    struct ComponentConfigView: View {
        @EnvironmentObject var componentConfigStore: ComponentConfigStore

        var component: EulComponent
        var config: Binding<EulComponentConfig> {
            $componentConfigStore[component]
        }

        var body: some View {
            SectionView(title: component.localizedDescription) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 12) {
                        Toggle(isOn: config.showIcon) {
                            Text("component.show_icon".localized())
                                .inlineSection()
                        }
                        if config.wrappedValue.component.isGraphAvailable {
                            Toggle(isOn: config.showGraph) {
                                Text("component.show_graph".localized())
                                    .inlineSection()
                            }
                        }
                    }
                    if component == .CPU {
                        ComponentTextConfigView<CpuTextComponent>()
                    }
                    if component == .Memory {
                        ComponentTextConfigView<MemoryTextComponent>()
                    }
                    if component == .Network {
                        ComponentTextConfigView<NetworkTextComponent>()
                    }
                    if component == .Battery {
                        ComponentTextConfigView<BatteryTextComponent>()
                    }
                    if component == .Disk {
                        ComponentTextConfigView<DiskTextComponent>()
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}
