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

    func getView() -> AnyView {
        switch self {
        case .Battery:
            return AnyView(BatteryView())
        case .CPU:
            return AnyView(CpuView())
        case .Fan:
            return AnyView(FanView())
        case .Memory:
            return AnyView(MemoryView())
        case .Network:
            return AnyView(NetworkView())
        }
    }

    func getMenuView() -> AnyView {
        switch self {
        case .Battery:
            return AnyView(BatteryMenuBlockView())
        case .CPU:
            return AnyView(CpuMenuBlockView())
        case .Fan:
            return AnyView(FanMenuBlockView())
        case .Memory:
            return AnyView(MemoryMenuBlockView())
        case .Network:
            return AnyView(NetworkMenuBlockMenuView())
        }
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network

    static var allCases: [EulComponent] {
        let components: [EulComponent] = [.CPU, .Fan, .Memory, .Network]
        return BatteryStore.shared.isValid ? components + [.Battery] : components
    }
}

protocol EulComponentMenu {
    var items: [NSMenuItem] { get }
}

typealias EulComponentMenuBuilder = () -> EulComponentMenu

struct StatusBarConfig {
    let viewBuilder: SizeChangeViewBuilder
    let menuBuilder: SizeChangeViewBuilder?
}

func getStatusBarConfig() -> StatusBarConfig {
    StatusBarConfig(
        viewBuilder: { AnyView(StatusBarView(onSizeChange: $0).withGlobalEnvironmentObjects()) },
        menuBuilder: { AnyView(StatusMenuView(onSizeChange: $0).withGlobalEnvironmentObjects()) }
    )
}
