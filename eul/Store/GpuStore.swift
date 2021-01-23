//
//  GpuStore.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation

class GpuStore: ObservableObject {
    init() {
        fetch()
    }

    func fetch() {
        GPU.getPCIDevices()
        GPU.getInfo()
    }
}
