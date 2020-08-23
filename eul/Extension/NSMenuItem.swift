//
//  NSMenuItem.swift
//  eul
//
//  Created by Gao Sun on 2020/8/23.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    static func forDisplay(with text: String) -> NSMenuItem {
        var item = NSMenuItem(title: text, action: nil, keyEquivalent: "")
        item.isEnabled = false
        return item
    }
}
