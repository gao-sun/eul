//
//  SmcControl.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary

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

extension Double {
    var temperatureString: String {
        SmcControl.shared.formatTemp(self)
    }
}

class SmcControl: Refreshable {
    static var shared = SmcControl()

    class TemperatureData {
        let sensor: TemperatureSensor
        var temp: Double

        init(sensor: TemperatureSensor, temp: Double = 0) {
            self.sensor = sensor
            self.temp = temp
        }
    }

    class FanData: Identifiable {
        let fan: Fan
        var speed: Int

        var id: Int {
            fan.id
        }

        var percentage: Double {
            Double(speed) / Double(fan.maxSpeed) * 100
        }

        init(fan: Fan, speed: Int = 0) {
            self.fan = fan
            self.speed = speed
        }
    }

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

    func formatTemp(_ value: Double) -> String {
        String(format: "%.0f°\(tempUnit == .celius ? "C" : "F")", value)
    }

    // must call a function explicitly to init shared instance
    func start() {
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
