//
//  EulComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

enum EulComponent: String, CaseIterable, Identifiable, Codable, JSONCodabble, LocalizedStringConvertible {
    var id: String {
        rawValue
    }

    var localizedDescription: String {
        "component.\(rawValue.lowercased())".localized()
    }

    var isGraphAvailable: Bool {
        guard [.CPU, .Memory, .GPU].contains(self) else {
            return false
        }
        return true
    }

    var isDiskSelectionAvailable: Bool {
        self == .Disk
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
        case .GPU:
            return AnyView(GpuView())
        }
    }

    case CPU
    case Fan
    case Memory
    case Battery
    case Network
    case Disk
    case GPU

    static var allCases: [EulComponent] {
        [.CPU, .GPU, .Memory]
            .appending(.Fan, condition: SmcControl.shared.isFanValid)
            .appending(.Network)
            .appending(.Battery, condition: SharedStore.battery.isValid)
            .appending(.Disk)
    }

    static var defaultComponents: [EulComponent] {
        allCases.filter { ![.Disk, .GPU].contains($0) }
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
