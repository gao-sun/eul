//
//  SmcControl.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SwiftyJSON

class SmcControl: Refreshable {
    static var shared = SmcControl()

    var sensors: [TemperatureData] = []
    var fans: [FanData] = []
    var tempUnit: TemperatureUnit = .celius
    var cpuProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "CPU_0_PROXIMITY" })?.temp
    }

    var gpuProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "GPU_0_PROXIMITY" })?.temp
    }

    var memoryProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "MEM_SLOTS_PROXIMITY" })?.temp
    }

    var isFanValid: Bool {
        fans.count > 0
    }

    func formatTemp(_ value: Double) -> String {
        String(format: "%.0f°\(tempUnit == .celius ? "C" : "F")", value)
    }

    init() {
        do {
            try SMCKit.open()
            sensors = try SMCKit.allKnownTemperatureSensors().map { .init(sensor: $0) }
            fans = try (0..<SMCKit.fanCount()).map { .init(
                fan: Fan(
                    id: $0,
                    name: $0.description,
                    minSpeed: try SMCKit.fanMinSpeed($0),
                    maxSpeed: try SMCKit.fanMaxSpeed($0)
                )
            ) }
        } catch {
            print("SMC init error", error)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func subscribe() {
        initObserver(for: .SMCShouldRefresh)
    }

    func close() {
        SMCKit.close()
    }

    @objc func refresh() {
        for sensor in sensors {
            do {
                sensor.temp = try SMCKit.temperature(sensor.sensor.code, unit: tempUnit)
            } catch {
                sensor.temp = 0
                print("error while getting temperature", error)
            }
        }
        for fan in fans {
            do {
                fan.speed = try SMCKit.fanCurrentSpeed(fan.fan.id)
            } catch {
                fan.speed = 0
                print("error while getting fan speed", error)
            }
        }
        NotificationCenter.default.post(name: .StoreShouldRefresh, object: nil)
    }
}

extension TemperatureUnit {
    var description: String {
        switch self {
        case .celius:
            return "temp.celsius".localized()
        case .fahrenheit:
            return "temp.fahrenheit".localized()
        case .kelvin:
            return "temp.kelvin".localized()
        }
    }
}

extension Fan: JSONCodabble {
    init?(json: JSON) {
        guard
            let id = json["id"].int,
            let name = json["name"].string,
            let minSpeed = json["id"].int,
            let maxSpeed = json["id"].int
        else {
            return nil
        }
        self.id = id
        self.name = name
        self.minSpeed = minSpeed
        self.maxSpeed = maxSpeed
    }

    var json: JSON {
        JSON([
            "id": id,
            "name": name,
            "minSpeed": minSpeed,
            "maxSpeed": maxSpeed,
        ])
    }
}

extension Double {
    var temperatureString: String {
        SmcControl.shared.formatTemp(self)
    }
}
