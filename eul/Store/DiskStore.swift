//
//  DiskStore.swift
//  eul
//
//  Created by Gao Sun on 2020/11/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary

class DiskStore: ObservableObject, Refreshable {
    @Published var list: DiskList?

    var ceilingBytes: UInt64? {
        list?.Containers.reduce(0) { $0 + $1.CapacityCeiling }
    }

    var freeBytes: UInt64? {
        list?.Containers.reduce(0) { $0 + $1.CapacityFree }
    }

    var usageString: String {
        guard let ceiling = ceilingBytes, let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(ceiling - free, kilo: 1000).readable
    }

    var freeString: String {
        guard let free = freeBytes else {
            return "N/A"
        }
        return ByteUnit(free, kilo: 1000).readable
    }

    @objc func refresh() {
        // APFS will be good from Catalina
        let plistString = shell("diskutil apfs list -plist") ?? ""
        let propertiesDecoder = PropertyListDecoder()

        if
            let data = plistString.data(using: .utf8),
            let list = try? propertiesDecoder.decode(DiskList.self, from: data)
        {
            self.list = list
        } else {
            list = nil
        }
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
    }
}
