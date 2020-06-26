//
//  AppDelegate.swift
//  eul
//
//  Created by Gao Sun on 2020/6/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var statusBarItem: NSStatusItem!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        let statusBarMenu = NSMenu()
        statusBarMenu.addItem(
        withTitle: "Exit",
        action: #selector(AppDelegate.exit),
        keyEquivalent: "")
        statusBarItem.menu = statusBarMenu
        statusBarItem.button?.title = "..."
        getTemp()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func exit() {
        NSApplication.shared.terminate(self)
    }

    func getTemp() {
        statusBarItem.button?.title = String(format: "%.1f °C", SMCObjC.calculateTemp())
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.getTemp()
        }
    }
}

