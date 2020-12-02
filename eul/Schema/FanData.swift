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

struct FanData: Identifiable {
    let id: Int
    var currentSpeed: Int?
    var minSpeed: Int?
    var maxSpeed: Int?

    var currentSpeedString: String {
        currentSpeed.map {
            "\($0) rpm"
        } ?? "N/A"
    }

    var minSpeedString: String {
        minSpeed.map {
            "\($0) rpm"
        } ?? "N/A"
    }

    var maxSpeedString: String {
        maxSpeed.map {
            "\($0) rpm"
        } ?? "N/A"
    }
}
