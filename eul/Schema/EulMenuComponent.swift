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
        case .GPU:
            return AnyView(GpuMenuBlockView())
        }
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network
    case Bluetooth
    case Disk
    case GPU

    static var allCases: [EulMenuComponent] {
        [.CPU, .GPU]
            .appending(.Fan, condition: SmcControl.shared.isFanValid)
            .appending([.Memory, .Network, .Bluetooth, .Disk])
            .appending(.Battery, condition: SharedStore.battery.isValid)
    }

    static var defaultComponents: [Self] {
        allCases.filter { ![.Bluetooth, .Disk].contains($0) }
    }
}
