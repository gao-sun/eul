//
//  SmcControl.swift
//  eul
//
//  Created by Gao Sun on 2020/6/27.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct SmcControl {
    static var shared = SmcControl()

    class TemperatureData {
        let sensor: TemperatureSensor
        var temp: Double

        init(sensor: TemperatureSensor, temp: Double = 0) {
            self.sensor = sensor
            self.temp = temp
        }
    }

    var sensors: [TemperatureData]
    var cpuProximityTemperature: Double {
        sensors.first(where: { $0.sensor.name == "CPU_0_PROXIMITY" })?.temp ?? 0
    }

    init() {
        sensors = []
        do {
            try SMCKit.open()
            sensors = try SMCKit.allKnownTemperatureSensors().map { .init(sensor: $0) }
        } catch let error {
            print("SMC init error", error)
        }
        SMCKit.close()
    }

    func refresh() {
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
        SMCKit.close()
    }
}
