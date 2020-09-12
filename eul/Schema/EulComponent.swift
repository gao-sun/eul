//
//  EulComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI

enum EulComponent: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    var localizedDescription: String {
        "component.\(rawValue.lowercased())".localized()
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network
}

protocol EulComponentMenu {
    var items: [NSMenuItem] { get }
}

typealias EulComponentMenuBuilder = () -> EulComponentMenu

struct ComponentConfig {
    let viewBuilder: SizeChangeViewBuilder
    let menuBuilder: SizeChangeViewBuilder?
}

func getComponentConfig(_ component: EulComponent) -> ComponentConfig {
    switch component {
    case .CPU:
        return ComponentConfig(
            viewBuilder: { AnyView(CpuView(onSizeChange: $0)) },
            menuBuilder: { AnyView(CpuMenuView(onSizeChange: $0)) }
        )
    case .Fan:
        return ComponentConfig(
            viewBuilder: { AnyView(FanView(onSizeChange: $0)) },
            menuBuilder: { AnyView(FanMenuView(onSizeChange: $0)) }
        )
    case .Memory:
        return ComponentConfig(
            viewBuilder: { AnyView(MemoryView(onSizeChange: $0)) },
            menuBuilder: { AnyView(MemoryMenuView(onSizeChange: $0)) }
        )
    case .Battery:
        return ComponentConfig(
            viewBuilder: { AnyView(BatteryView(onSizeChange: $0)) },
            menuBuilder: { AnyView(BatteryMenuView(onSizeChange: $0)) }
        )
    case .Network:
        return ComponentConfig(viewBuilder: { AnyView(NetworkView(onSizeChange: $0)) }, menuBuilder: nil)
    }
}
