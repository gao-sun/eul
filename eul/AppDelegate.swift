//
//  AppDelegate.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import Localize_Swift
import SharedLibrary
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    static var statusBarHeight: CGFloat {
        NSStatusBar.system.thickness
    }

    static func openPreferences() {
        (NSApp.delegate as! AppDelegate).window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        NotificationCenter.default.post(name: .StatusBarMenuShouldClose, object: nil)
    }

    static func quit() {
        NSApplication.shared.terminate(self)
    }

    var window: NSWindow!
    let statusBarManager = StatusBarManager()
    @ObservedObject var preferenceStore = PreferenceStore.shared

    func refreshSMCRepeatedly() {
        NotificationCenter.default.post(name: .SMCShouldRefresh, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(preferenceStore.smcRefreshRate)) { [self] in
            refreshSMCRepeatedly()
        }
    }

    func refreshNetworkRepeatedly() {
        NotificationCenter.default.post(name: .NetworkShouldRefresh, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(preferenceStore.networkRefreshRate)) { [self] in
            refreshNetworkRepeatedly()
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
        window.contentView = NSHostingView(rootView: contentView.withGlobalEnvironmentObjects())
        window.isReleasedWhenClosed = false
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.delegate = self

        // comment out for not showing window at login. no proper solution currently, tracking:
        // https://github.com/sindresorhus/LaunchAtLogin/issues/33
        // window.makeKeyAndOrderFront(nil)
        // NSApp.activate(ignoringOtherApps: true)

        SmcControl.shared.start()
        refreshSMCRepeatedly()
        refreshNetworkRepeatedly()
    }

    func windowDidBecomeMain(_: Notification) {
        PreferenceStore.shared.checkUpdate()
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}
