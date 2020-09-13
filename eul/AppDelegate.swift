//
//  AppDelegate.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import Localize_Swift
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let statusBarManager = StatusBarManager()

    static var statusBarHeight: CGFloat {
        NSStatusBar.system.thickness
    }

    func refreshRepeatedly() {
        NotificationCenter.default.post(name: .SMCShouldRefresh, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.refreshRepeatedly()
        }
    }

    func applicationDidFinishLaunching(_: Notification) {
        let contentView = ContentView()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.center()
        window.setFrameAutosaveName("Eul Preferences")
        window.contentView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.makeKeyAndOrderFront(nil)
        SmcControl.shared.start()
        refreshRepeatedly()
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }

    @objc func open() {
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func exit() {
        NSApplication.shared.terminate(self)
    }
}
