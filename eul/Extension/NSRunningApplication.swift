//
//  NSRunningApplication.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import AppKit

extension NSRunningApplication {
    var canBeActivated: Bool {
        activationPolicy == .regular || activationPolicy == .accessory
    }
}
