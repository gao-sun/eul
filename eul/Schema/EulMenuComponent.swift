//
//  EulMenuComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/10/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

enum EulMenuComponent: String, CaseIterable, Identifiable, JSONCodabble {
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
        case .Bluetooth:
            return AnyView(BluetoothMenuBlockView())
        case .Disk:
            return AnyView(DiskMenuBlockView())
        }
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network
    case Bluetooth
    case Disk

    static var allCases: [EulMenuComponent] {
        let components: [EulMenuComponent] = [.CPU, .Fan, .Memory, .Network, .Bluetooth, .Disk]
        return SharedStore.battery.isValid ? components + [.Battery] : components
    }

    static var defaultComponents: [Self] {
        allCases.filter { ![.Bluetooth, .Disk].contains($0) }
    }
}
