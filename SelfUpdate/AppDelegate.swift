//
//  AppDelegate.swift
//  SelfUpdate
//
//  Created by Gao Sun on 2021/2/12.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let fileManager = FileManager.default

    static func quit() {
        NSApplication.shared.terminate(self)
    }

    func update() {
        defer {
            AppDelegate.quit()
        }

        let arguments = CommandLine.arguments
        let newAppUrl = URL(fileURLWithPath: arguments[1]).appendingPathComponent("eul.app")
        let appUrl = URL(fileURLWithPath: arguments[2]).appendingPathComponent("eul.app")
        let pidArg = pid_t(arguments[3])

        guard
            let pid = pidArg,
            let currentApp = NSWorkspace.shared.runningApplications.first(where: { $0.processIdentifier == pid })
        else {
            print("current app not found with pid", pidArg ?? "N/A")
            return
        }

        var isDirectory: ObjCBool = false

        guard fileManager.fileExists(atPath: newAppUrl.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            print("new app not found at", newAppUrl)
            return
        }

        print("terminating current app")
        guard currentApp.terminate() || currentApp.forceTerminate() else {
            print("cannot terminate current app")
            return
        }

        do {
            print("removing old app", appUrl)
            try fileManager.removeItem(at: appUrl)
            print("copying new app from", newAppUrl, "to", appUrl)
            try fileManager.copyItem(at: newAppUrl, to: appUrl)
        } catch {
            print("error when setting up new app", error)
            return
        }

        print("opening app")
        guard NSWorkspace.shared.open(appUrl) else {
            print("failed to open app")
            return
        }

        print("update fininshed")
    }

    func applicationDidFinishLaunching(_: Notification) {
        update()

        guard CommandLine.arguments.contains("--debug") else {
            return
        }

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}
