//
//  EulComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI

enum EulComponent: String, CaseIterable, Identifiable, Codable {
    var id: String {
        rawValue
    }

    var localizedDescription: String {
        "component.\(rawValue.lowercased())".localized()
    }

    var isGraphAvailable: Bool {
        guard self == .CPU || self == .Memory else {
            return false
        }
        return true
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
        case .Disk:
            return AnyView(DiskView())
        }
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network
    case Disk

    static var allCases: [EulComponent] {
        let components: [EulComponent] = [.CPU, .Fan, .Memory, .Network, .Disk]
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
