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

struct StatusBarConfig {
    let viewBuilder: SizeChangeViewBuilder
    let menuBuilder: SizeChangeViewBuilder?
}

func getStatusBarConfig() -> StatusBarConfig {
    StatusBarConfig(viewBuilder: { AnyView(StatusBarView(onSizeChange: $0).withGlobalEnvironmentObjects()) }, menuBuilder: nil)
}
