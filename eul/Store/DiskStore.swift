//
//  DiskStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SwiftUI

class DiskStore: ObservableObject, Refreshable {
    static let volumesPath = "/Volumes"

    @Published var list: DiskList?
    @ObservedObject var componentsStore = SharedStore.components

    var ceilingBytes: UInt64? {
        list?.disks.reduce(0) { $0 + $1.size }
    }

    var freeBytes: UInt64? {
        list?.disks.reduce(0) { $0 + $1.freeSize }
    }

    var usageString: String {
        guard let ceiling = ceilingBytes, let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(ceiling - free, kilo: 1000).readable
    }

    var usagePercentageString: String {
        guard let ceiling = ceilingBytes, let free = freeBytes else {
            return "N/A"
        }
        return (Double(ceiling - free) / Double(ceiling)).percentageString
    }

    var freeString: String {
        guard let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(free, kilo: 1000).readable
    }

    var totalString: String {
        guard let ceiling = ceilingBytes else {
            return "N/A"
        }
        return ByteUnit(ceiling, kilo: 1000).readable
    }

    @objc func refresh() {
        guard componentsStore.activeComponents.contains(.Disk) else {
            return
        }

        let volumes = (try? FileManager.default.contentsOfDirectory(atPath: DiskStore.volumesPath)) ?? []

        list = DiskList(disks: volumes.compactMap {
            guard
                let attributes = try? FileManager.default.attributesOfFileSystem(forPath: DiskStore.volumesPath + "/" + $0),
                let size = attributes[FileAttributeKey.systemSize] as? UInt64,
                let freeSize = attributes[FileAttributeKey.systemFreeSize] as? UInt64
            else {
                return nil
            }

            return DiskList.Disk(name: $0, size: size, freeSize: freeSize)
        })
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
