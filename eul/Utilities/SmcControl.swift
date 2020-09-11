//
//  SmcControl.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

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

        init(fan: Fan, speed: Int = 0) {
            self.fan = fan
            self.speed = speed
        }
    }

    var sensors: [TemperatureData] = []
    var fans: [FanData] = []
    var cpuProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "CPU_0_PROXIMITY" })?.temp
    }
    var gpuProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "GPU_0_PROXIMITY" })?.temp
    }
    var memoryProximityTemperature: Double? {
        sensors.first(where: { $0.sensor.name == "MEM_SLOTS_PROXIMITY" })?.temp
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
        } catch let error {
            print("SMC init error", error)
        }
        SMCKit.close()
        initObserver(for: .SMCShouldRefresh)
    }

    @objc func refresh() {
        do {
            try SMCKit.open()
        } catch let error {
            SMCKit.close()
            print("error while opening SMC", error)
            return
        }
        for sensor in sensors {
            do {
                sensor.temp = try SMCKit.temperature(sensor.sensor.code)
            } catch let error {
                sensor.temp = 0
                print("error while getting temperature", error)
            }
        }
        for fan in fans {
            do {
                fan.speed = try SMCKit.fanCurrentSpeed(fan.fan.id)
            } catch let error {
                fan.speed = 0
                print("error while getting fan speed", error)
            }
        }
        SMCKit.close()
        NotificationCenter.default.post(name: .StoreShouldRefresh, object: nil)
    }
}
