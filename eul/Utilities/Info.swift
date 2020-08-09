//
//  Info.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SystemKit
import IOKit.ps

struct Info {
    struct Battery {
        var currentCapacity = 0
        var maxCapacity = 0
        var currentPercentage: Int {
            Int(Double(currentCapacity) / Double(maxCapacity) * 100)
        }

        init() {
            guard
                let blob = IOPSCopyPowerSourcesInfo(),
                let list = IOPSCopyPowerSourcesList(blob.takeRetainedValue()),
                let array = list.takeRetainedValue() as? [Any],
                array.count > 0,
                let dict = array[0] as? NSDictionary
            else {
                return
            }

            currentCapacity = dict[kIOPSCurrentCapacityKey] as? Int ?? 0
            maxCapacity = dict[kIOPSMaxCapacityKey] as? Int ?? 0
        }
    }

    struct Network {
        var interface: String
        var inBytes: UInt
        var outBytes: UInt

        init() {
            interface = shell("route get 0.0.0.0 | grep interface | awk '{print $2}'")?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? "en0"
            inBytes = 0
            outBytes = 0

            if
                let rows = shell("netstat -bI \(interface)")?.split(separator: "\n").map({ String($0) }),
                rows.count > 1
            {
                let headers = rows[0].splittedByWhitespace
                let values = rows[1].splittedByWhitespace

                if let raw = String.getValue(of: "ibytes", in: values, of: headers), let bytes = UInt(raw) {
                    inBytes = bytes
                }

                if let raw = String.getValue(of: "obytes", in: values, of: headers), let bytes = UInt(raw) {
                    outBytes = bytes
                }
            }
        }
    }

    static var system = System()
}
