//
//  Int.swift
//  eul
//
//  Created by Gao Sun on 2020/10/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public extension Int {
    var digitCount: Int {
        var n = self
        var count = 0
        while n > 0 {
            count += 1
            n /= 10
        }
        return count
    }

    var readableTimeInMin: String {
        if self <= 0 {
            return "0 min"
        }

        var result = [String]()
        let hour = self / 60
        let minute = self % 60

        if hour > 0 {
            result.append("\(hour) hr")
        }

        if minute > 0 {
            result.append("\(minute) min")
        }

        return result.joined(separator: " ")
    }
}
