//
//  SharedStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

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
}
