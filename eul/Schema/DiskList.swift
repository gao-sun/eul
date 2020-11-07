//
//  DiskList.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct DiskList: Codable {
    struct Container: Codable {
        let APFSContainerUUID: String
        let CapacityCeiling: UInt64
        let CapacityFree: UInt64
        let ContainerReference: String
    }

    let Containers: [Container]
}
