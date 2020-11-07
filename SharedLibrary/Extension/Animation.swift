//
//  Animation.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public extension Animation {
    static let normal = Animation.spring(dampingFraction: 1.5).speed(2.5)
    static let fast = Animation.spring(response: 0.3, dampingFraction: 1).speed(2)
    static let slow = Animation.spring(dampingFraction: 1.5).speed(1)
}
