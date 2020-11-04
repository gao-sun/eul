//
//  Int.swift
//  eul
//
//  Created by Gao Sun on 2020/10/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

extension Int {
    var digitCount: Int {
        var n = self
        var count = 0
        while n > 0 {
            count += 1
            n /= 10
        }
        return count
    }
}
