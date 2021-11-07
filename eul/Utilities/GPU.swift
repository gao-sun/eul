//
//  GPU.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Foundation

struct GPU: Identifiable {
    var deviceId: String
    var model: String?
    var vendor: String?

    var id: String {
        deviceId
    }
}

extension GPU {
    struct Statistic {
        var pciMatch: String
        var usagePercentage: Int
        var temperature: Double?
        var coreClock: Int?
        var memoryClock: Int?
    }
}

extension GPU {
    static func getGPUs() -> [GPU]? {
        guard let data = shellData(["system_profiler SPDisplaysDataType -xml"]) else {
            return nil
        }

        let pListDecoder = PropertyListDecoder()
        guard let plistArray = try? pListDecoder.decode(SystemProfilerPlistArray.self, from: data) else {
            return nil
        }

        return plistArray.first?.items.compactMap {
            guard $0.isGPU, let deviceId = $0.deviceId else {
                return nil
            }
            return GPU(deviceId: deviceId, model: $0.model, vendor: $0.vendor)
        }
    }

    // https://stackoverflow.com/questions/10110658/programmatically-get-gpu-percent-usage-in-os-x/22440235#22440235
    // https://github.com/exelban/stats/blob/master/Modules/GPU/reader.swift
    static func getInfo() -> [Statistic]? {
        guard let propertyList = IOHelper.getPropertyList(for: kIOAcceleratorClassName) else {
            return nil
        }

        return propertyList.compactMap {
            guard
                let pciMatch = $0["IOPCIMatch"] as? String ?? $0["IOPCIPrimaryMatch"] as? String,
                let statistics = $0["PerformanceStatistics"] as? [String: Any],
                let usagePercentage = statistics["Device Utilization %"] as? Int ?? statistics["GPU Activity(%)"] as? Int
            else {
                return nil
            }

            var temperature: Double? = statistics["Temperature(C)"] as? Double ?? nil

            if temperature == nil || temperature == 0 {
                temperature = SmcControl.shared.gpuProximityTemperature
            }

            Print("📊 statistics", statistics)

            return Statistic(
                pciMatch: pciMatch,
                usagePercentage: usagePercentage,
                temperature: temperature,
                coreClock: statistics["Core Clock(MHz)"] as? Int,
                memoryClock: statistics["Memory Clock(MHz)"] as? Int
            )
        }
    }
}
