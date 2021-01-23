//
//  GPU.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation

enum GPU {
    static func getInfo() {
        guard let propertyList = IOHelper.getPropertyList(for: kIOAcceleratorClassName) else {
            return
        }

        propertyList.forEach {
            guard
                let ioClass = $0["IOClass"] as? String,
                let statistics = $0["PerformanceStatistics"] as? [String: Any]
            else {
                return
            }
        }
    }
}
