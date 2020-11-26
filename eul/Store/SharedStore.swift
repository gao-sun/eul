//
//  SharedStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

enum SharedStore {
    static let battery = BatteryStore()
    static let cpu = CpuStore()
    static let cpuTop = CpuTopStore()
    static let disk = DiskStore()
    static let fan = FanStore()
    static let memory = MemoryStore()
    static let network = NetworkStore()
    static let networkTop = NetworkTopStore()
    static let preference = PreferenceStore()
    static let ui = UIStore()
    static let components = ComponentsStore<EulComponent>()
    static let menuComponents = ComponentsStore<EulMenuComponent>()
    static let componentConfig = ComponentConfigStore()
    static let cpuTextComponents = ComponentsStore<CpuTextComponent>()
    static let memoryTextComponents = ComponentsStore<MemoryTextComponent>(
        defaultComponents: MemoryTextComponent.defaultComponents
    )
    static let networkTextComponents = ComponentsStore<NetworkTextComponent>()
    static let batteryTextComponents = ComponentsStore<BatteryTextComponent>(
        defaultComponents: BatteryTextComponent.defaultComponents
    )
    static let diskTextComponents = ComponentsStore<DiskTextComponent>(
        defaultComponents: DiskTextComponent.defaultComponents
    )
}

extension View {
    func withGlobalEnvironmentObjects() -> some View {
        environmentObject(SharedStore.ui)
            .environmentObject(SharedStore.battery)
            .environmentObject(SharedStore.cpu)
            .environmentObject(SharedStore.cpuTop)
            .environmentObject(SharedStore.fan)
            .environmentObject(SharedStore.memory)
            .environmentObject(SharedStore.network)
            .environmentObject(SharedStore.networkTop)
            .environmentObject(SharedStore.disk)
            .environmentObject(SharedStore.preference)
            .environmentObject(SharedStore.components)
            .environmentObject(SharedStore.menuComponents)
            .environmentObject(SharedStore.componentConfig)
            .environmentObject(SharedStore.cpuTextComponents)
            .environmentObject(SharedStore.memoryTextComponents)
            .environmentObject(SharedStore.networkTextComponents)
            .environmentObject(SharedStore.batteryTextComponents)
            .environmentObject(SharedStore.diskTextComponents)
    }
}
