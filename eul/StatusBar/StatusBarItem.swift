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
    static let launchTime = Date()

    @ObservedObject var preferenceStore = SharedStore.preference
    @ObservedObject var componentsStore = SharedStore.components

    let config: StatusBarConfig
    private let statusBarMenu: NSMenu
    private let item: NSStatusItem
    private var statusView: NSHostingView<AnyView>?
    private var menuView: NSHostingView<AnyView>?
    private var shouldCloseObserver: NSObjectProtocol?
    private var visibilityTimer: Timer?
    private var statusBarSizeChanged = 0

    var isVisible: Bool {
        get { item.isVisible }
        set {
            item.isVisible = newValue
        }
    }

    func onSizeChange(size: CGSize) {
        let width = size.width + (Info.isBigSur ? 8 : 12) + (componentsStore.showComponents ? 0 : -8)

        DispatchQueue.main.async { [self] in
            statusBarSizeChanged += 1
            item.length = width
            statusView?.setFrameSize(NSSize(width: width, height: AppDelegate.statusBarHeight))
        }
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
        SharedStore.ui.menuWidth = menu.size.width
        SharedStore.ui.menuOpened = true
    }

    func menuDidClose(_: NSMenu) {
        SharedStore.ui.menuOpened = false
    }

    func checkVisibilityIfNeeded() {
        guard preferenceStore.checkStatusItemVisibility else {
            return
        }

        // add delay on launch due to potential false alarm
        let interval = max(15 + StatusBarItem.launchTime.timeIntervalSinceNow, 1.5)
        visibilityTimer?.invalidate()
        visibilityTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
            self.checkStatusItemVisibility()
        })
    }

    func setAppearance(_ appearance: NSAppearance?) {
        statusBarMenu.appearance = appearance
    }

    private func checkStatusItemVisibility() {
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
                SharedStore.ui.activeSection = .components
                AppDelegate.openPreferences()
            }
        } else {
            Print("✅ status item is visible")
        }
    }

    init(named: String = "eul") {
        config = getStatusBarConfig()
        statusBarMenu = NSMenu()
        item = NSStatusBar.system.statusItem(withLength: 0)
        super.init()

        statusBarMenu.delegate = self
        item.autosaveName = named
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

        // Small trick to forcely trigger re-render
        // Prevent wrong icon position when not showing status bar components
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            guard statusBarSizeChanged <= 1 else {
                return
            }
            componentsStore.showComponents = componentsStore.showComponents
        }
    }

    deinit {
        if let observer = shouldCloseObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
