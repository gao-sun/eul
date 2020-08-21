//
//  StatusBarItem.swift
//  eul
//
//  Created by Gao Sun on 2020/8/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI

class StatusBarItem<Content: SizeChangeView> {
    let item: NSStatusItem
    var statusView: NSHostingView<Content>?

    func onSizeChange(size: CGSize) {
        let width = size.width + 20
        item.length = width
        statusView?.frame = NSMakeRect(0, 0, width, StatusBarView.height)
    }

    init(with builder: (SizeChange) -> Content) {
        item = NSStatusBar.system.statusItem(withLength: 0)
        statusView = NSHostingView(rootView: builder(onSizeChange))

        let statusBarMenu = NSMenu()
        statusBarMenu.addItem(
            withTitle: "Exit",
            action: #selector(AppDelegate.exit),
            keyEquivalent: ""
        )
        item.menu = statusBarMenu

        if let statusView = statusView {
            statusView.frame = NSMakeRect(0, 0, 0, StatusBarView.height)
            item.button?.addSubview(statusView)
        }
    }
}
