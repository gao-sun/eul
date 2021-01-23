//
//  DiskList.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct DiskList {
    struct Disk {
        let name: String
        let size: UInt64
        let freeSize: UInt64
    }

    let disks: [Disk]
}
