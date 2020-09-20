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
    let config: StatusBarConfig
    private let item: NSStatusItem
    private var statusView: NSHostingView<AnyView>?
    private var menuView: NSHostingView<AnyView>?
    private let versionItem: NSMenuItem
    private let preferencesItem: NSMenuItem
    private let quitItem: NSMenuItem

    var isVisible: Bool {
        get { item.isVisible }
        set { item.isVisible = newValue }
    }

    func onSizeChange(size: CGSize) {
        let width = size.width + (Info.isBigSur ? 8 : 12)

        item.length = width
        statusView?.frame = NSMakeRect(0, 0, width, AppDelegate.statusBarHeight)
    }

    func onMenuSizeChange(size: CGSize) {
        menuView?.frame = NSMakeRect(0, 0, size.width, size.height)
    }

    func updateLanguage() {
        preferencesItem.title = "menu.preferences".localized()
        quitItem.title = "menu.quit".localized()
    }

    func refresh() {
        let view = NSHostingView(rootView: config.viewBuilder(onSizeChange))
        view.frame = NSMakeRect(0, 0, 0, AppDelegate.statusBarHeight)
        item.button?.subviews.forEach { $0.removeFromSuperview() }
        item.button?.addSubview(view)
        statusView = view
    }

    init() {
        config = getStatusBarConfig()
        item = NSStatusBar.system.statusItem(withLength: 0)
        item.isVisible = false

        versionItem = NSMenuItem(
            title: "eul v\(PreferenceStore.shared.version ?? "?")",
            action: nil,
            keyEquivalent: ""
        )
        preferencesItem = NSMenuItem(
            title: "menu.preferences".localized(),
            action: #selector(AppDelegate.open),
            keyEquivalent: ","
        )
        preferencesItem.keyEquivalentModifierMask = .command

        quitItem = NSMenuItem(
            title: "menu.quit".localized(),
            action: #selector(AppDelegate.exit),
            keyEquivalent: "q"
        )
        quitItem.keyEquivalentModifierMask = .command

        let statusBarMenu = NSMenu()

        if let menuBuilder = config.menuBuilder {
            let customItem = NSMenuItem()
            menuView = NSHostingView(rootView: menuBuilder(onMenuSizeChange))
            customItem.view = menuView
            statusBarMenu.addItem(customItem)
            statusBarMenu.addItem(NSMenuItem.separator())
        }

        statusBarMenu.addItem(versionItem)
        statusBarMenu.addItem(preferencesItem)
        statusBarMenu.addItem(quitItem)
        item.menu = statusBarMenu

        refresh()
    }
}
