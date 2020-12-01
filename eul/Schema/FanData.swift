//
//  FanData.swift
//  eul
//
//  Created by Gao Sun on 2020/12/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SwiftyJSON

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
