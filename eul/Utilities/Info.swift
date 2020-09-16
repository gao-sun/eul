//
//  Info.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import IOKit.ps
import SystemKit

struct Info {
    static var isBigSur: Bool {
        let version = ProcessInfo().operatingSystemVersion
        return !(version.majorVersion <= 10 && version.minorVersion < 16)
    }

    enum BatteryCondition: String {
        case good
        case fair
        case poor

        var description: String {
            "battery.condition.\(rawValue)".localized()
        }
    }

    enum PowerSourceState: String {
        case battery
        case acPower
        case unknown

        var description: String {
            "battery.power_source.\(rawValue)".localized()
        }
    }

    struct Battery {
        var currentCapacity = 0
        var maxCapacity = 0
        var currentCharge: Double {
            Double(currentCapacity) / Double(maxCapacity)
        }

        var condition: BatteryCondition = .good
        var powerSource: PowerSourceState = .unknown
        var timeToFullCharge = 0
        var timeToEmpty = 0
        var isCharged = false
        var isCharging = false

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
            timeToFullCharge = dict[kIOPSTimeToFullChargeKey] as? Int ?? 0
            timeToEmpty = dict[kIOPSTimeToEmptyKey] as? Int ?? 0
            isCharged = dict[kIOPSIsChargedKey] as? Bool ?? false
            isCharging = dict[kIOPSIsChargingKey] as? Bool ?? false

            if let value = dict[kIOPSBatteryHealthConditionKey] as? String {
                switch value {
                case kIOPSPoorValue:
                    condition = .poor
                case kIOPSFairValue:
                    condition = .fair
                default:
                    condition = .good
                }
            }

            if let value = dict[kIOPSPowerSourceStateKey] as? String {
                switch value {
                case kIOPSACPowerValue:
                    powerSource = .acPower
                case kIOPSBatteryPowerValue:
                    powerSource = .battery
                default:
                    powerSource = .unknown
                }
            }
        }
    }

    struct Network {
        var interface: String
        var inBytes: UInt64
        var outBytes: UInt64

        init() {
            interface = shell("route get 0.0.0.0 | grep interface | awk '{print $2}'")?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? "en0"
            inBytes = 0
            outBytes = 0

            if
                let rows = shell("netstat -bI \(interface)")?.split(separator: "\n").map({ String($0) }),
                rows.count > 1 {
                let headers = rows[0].splittedByWhitespace
                let values = rows[1].splittedByWhitespace

                if let raw = String.getValue(of: "ibytes", in: values, of: headers), let bytes = UInt64(raw) {
                    inBytes = bytes
                }

                if let raw = String.getValue(of: "obytes", in: values, of: headers), let bytes = UInt64(raw) {
                    outBytes = bytes
                }
            }
        }
    }

    static var system = System()
}
