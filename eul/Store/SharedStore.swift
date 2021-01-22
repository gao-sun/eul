//
//  SharedStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

enum SharedStore {
    static let visibilityCheckClosure = { StatusBarManager.shared.checkVisibilityIfNeeded() }
    static let battery = BatteryStore()
    static let cpu = CpuStore()
    static let cpuTop = CpuTopStore()
    static let disk = DiskStore()
    static let fan = FanStore()
    static let memory = MemoryStore()
    static let network = NetworkStore()
    static let networkTop = NetworkTopStore()
    static let bluetooth = BluetoothStore()
    static let preference = PreferenceStore()
    static let ui = UIStore()
    static let components = ComponentsStore<EulComponent>(onDidChange: visibilityCheckClosure)
    static let menuComponents = ComponentsStore<EulMenuComponent>(defaultComponents: EulMenuComponent.defaultComponents)
    static let componentConfig = ComponentConfigStore(onDidChange: visibilityCheckClosure)
    static let cpuTextComponents = ComponentsStore<CpuTextComponent>(
        defaultComponents: CpuTextComponent.defaultComponents,
        onDidChange: visibilityCheckClosure
    )
    static let memoryTextComponents = ComponentsStore<MemoryTextComponent>(
        defaultComponents: MemoryTextComponent.defaultComponents,
        onDidChange: visibilityCheckClosure
    )
    static let networkTextComponents = ComponentsStore<NetworkTextComponent>(
        onDidChange: visibilityCheckClosure
    )
    static let batteryTextComponents = ComponentsStore<BatteryTextComponent>(
        defaultComponents: BatteryTextComponent.defaultComponents,
        onDidChange: visibilityCheckClosure
    )
    static let diskTextComponents = ComponentsStore<DiskTextComponent>(
        defaultComponents: DiskTextComponent.defaultComponents,
        onDidChange: visibilityCheckClosure
    )
    static let fanTextComponents = ComponentsStore<FanTextComponent>(
        defaultComponents: FanTextComponent.defaultComponents,
        onDidChange: visibilityCheckClosure
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
            .environmentObject(SharedStore.bluetooth)
            .environmentObject(SharedStore.preference)
            .environmentObject(SharedStore.components)
            .environmentObject(SharedStore.menuComponents)
            .environmentObject(SharedStore.componentConfig)
            .environmentObject(SharedStore.cpuTextComponents)
            .environmentObject(SharedStore.memoryTextComponents)
            .environmentObject(SharedStore.networkTextComponents)
            .environmentObject(SharedStore.batteryTextComponents)
            .environmentObject(SharedStore.diskTextComponents)
            .environmentObject(SharedStore.fanTextComponents)
    }
}
