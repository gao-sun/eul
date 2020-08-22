//
//  StatusBarItem.swift
//  eul
//
//  Created by Gao Sun on 2020/8/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI


class StatusBarItem {
    let component: EulComponent
    private let item: NSStatusItem
    private var statusView: NSHostingView<AnyView>?

    var isVisible: Bool {
        get { item.isVisible }
        set { item.isVisible = newValue }
    }

    func onSizeChange(size: CGSize) {
        let width = size.width + 12
        item.length = width
        statusView?.frame = NSMakeRect(0, 0, width, AppDelegate.statusBarHeight)
    }

    init(with component: EulComponent) {
        let config = getComponentConfig(component)
        self.component = component
        item = NSStatusBar.system.statusItem(withLength: 0)
        item.isVisible = false
        statusView = NSHostingView(rootView: config.viewBuilder(onSizeChange))

        let statusBarMenu = NSMenu()
        statusBarMenu.addItem(
            withTitle: "Exit eul",
            action: #selector(AppDelegate.exit),
            keyEquivalent: ""
        )
        item.menu = statusBarMenu

        if let statusView = statusView {
            statusView.frame = NSMakeRect(0, 0, 0, AppDelegate.statusBarHeight)
            item.button?.addSubview(statusView)
        }
    }
}
