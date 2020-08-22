//
//  StatusBarManager.swift
//  eul
//
//  Created by Gao Sun on 2020/8/22.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

class StatusBarManager {
    let cpu = StatusBarItem(with: .CPU)
    let fan = StatusBarItem(with: .Fan)
    let memory = StatusBarItem(with: .Memory)
    let battery = StatusBarItem(with: .Battery)
    let Network = StatusBarItem(with: .Network)
}
