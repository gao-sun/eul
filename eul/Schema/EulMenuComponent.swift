//
//  EulMenuComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/10/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI

enum EulMenuComponent: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }

    var localizedDescription: String {
        "component.\(rawValue.lowercased())".localized()
    }

    func getView() -> AnyView {
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

    static var allCases: [EulMenuComponent] {
        let components: [EulMenuComponent] = [.CPU, .Fan, .Memory, .Network]
        return BatteryStore.shared.isValid ? components + [.Battery] : components
    }
}
