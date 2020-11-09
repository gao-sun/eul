//
//  StatusBarItem.swift
//  eul
//
//  Created by Gao Sun on 2020/8/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI

extension Notification.Name {
    static let StatusBarMenuShouldClose = Notification.Name("StatusBarMenuShouldClose")
}

class StatusBarItem: NSObject, NSMenuDelegate {
    let config: StatusBarConfig
    private let statusBarMenu: NSMenu
    private let item: NSStatusItem
    private var statusView: NSHostingView<AnyView>?
    private var menuView: NSHostingView<AnyView>?
    private var shouldCloseObserver: NSObjectProtocol?

    var isVisible: Bool {
        get { item.isVisible }
        set {
            item.isVisible = newValue
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.checkStatusItemVisibility()
                }
            }
        }
    }

    func onSizeChange(size: CGSize) {
        let width = size.width + (Info.isBigSur ? 8 : 12)

        item.length = width
        statusView?.setFrameSize(NSSize(width: width, height: AppDelegate.statusBarHeight))
    }

    func onMenuSizeChange(size: CGSize) {
        menuView?.setFrameSize(NSSize(width: size.width, height: size.height))
    }

    func refresh() {
        let view = NSHostingView(rootView: config.viewBuilder(onSizeChange))
        view.setFrameSize(NSSize(width: 0, height: AppDelegate.statusBarHeight))
        item.button?.subviews.forEach { $0.removeFromSuperview() }
        item.button?.addSubview(view)
        statusView = view
    }

    func menuWillOpen(_ menu: NSMenu) {
        UIStore.shared.menuWidth = menu.size.width
    }

    func checkStatusItemVisibility() {
        if item.button?.window?.occlusionState.contains(.visible) == false {
            print("⚠️ status item hidden by system")
            let alert = NSAlert()
            alert.messageText = "ui.hidden_by_system.title".localized()
            alert.informativeText = "ui.hidden_by_system.message".localized()
            alert.alertStyle = .warning
            alert.addButton(withTitle: "ui.hidden_by_system.open".localized())
            alert.addButton(withTitle: "ui.hidden_by_system.dismiss".localized())
            NSApp.activate(ignoringOtherApps: true)

            let result = alert.runModal()
            if result == .alertFirstButtonReturn {
                UIStore.shared.activeSection = .components
                AppDelegate.openPreferences()
            }
        } else {
            print("✅ status item is visible")
        }
    }

    override init() {
        config = getStatusBarConfig()
        statusBarMenu = NSMenu()
        item = NSStatusBar.system.statusItem(withLength: 0)
        super.init()

        statusBarMenu.delegate = self
        item.isVisible = false

        if let menuBuilder = config.menuBuilder {
            let customItem = NSMenuItem()
            menuView = StatusBarMenuHostingView(rootView: menuBuilder(onMenuSizeChange))
            menuView?.translatesAutoresizingMaskIntoConstraints = false
            menuView?.setFrameSize(NSSize(width: 1, height: 1))
            customItem.view = menuView
            statusBarMenu.addItem(customItem)
        }

        item.menu = statusBarMenu

        shouldCloseObserver = NotificationCenter.default.addObserver(forName: .StatusBarMenuShouldClose, object: nil, queue: nil) { _ in
            self.statusBarMenu.cancelTracking()
        }

        refresh()
    }

    deinit {
        if let observer = shouldCloseObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
