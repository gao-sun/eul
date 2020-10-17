//
//  ProcessRowView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ProcessRowView<Usage: ProcessUsage>: View {
    let process: Usage
    var nameWidth: CGFloat = 200
    var valueViewBuilder: (() -> AnyView)? = nil

    var body: some View {
        HStack {
            Text(process.displayName)
                .secondaryDisplayText()
                .frame(width: nameWidth, alignment: .leading)
                .lineLimit(1)
            Spacer()
            if let builder = valueViewBuilder {
                builder()
            } else {
                Text(process.value.description)
                    .displayText()
            }
            HStack(spacing: 6) {
                if let runningApp = process.runningApp, runningApp.canBeActivated {
                    MenuActionButtonView(id: "\(process.pid)-nagivate", imageName: "Navigate", toolTip: "process.bring_to_front") {
                        if runningApp.isActive {
                            NotificationCenter.default.post(name: .StatusBarMenuShouldClose, object: nil)
                        } else {
                            _ = runningApp.activate(options: .activateIgnoringOtherApps)
                        }
                    }
                }
                MenuActionButtonView(id: "\(process.pid)-open", imageName: "Folder", toolTip: "process.reveal_in_finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: process.command, isDirectory: false)])
                }
                MenuActionButtonView(id: "\(process.pid)-terminate", imageName: "Terminate", toolTip: "process.terminate") {
                    let alert = NSAlert()
                    alert.messageText = "process.terminate_alert.text.%@".localizedFormat(process.displayName)
                    alert.informativeText = "process.terminate_alert.command.%@".localizedFormat(process.command)
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "process.terminate_alert.cancel".localized())
                    alert.addButton(withTitle: "process.force_terminate".localized())
                    alert.addButton(withTitle: "process.terminate".localized())
                    NSApp.activate(ignoringOtherApps: true)

                    let result = alert.runModal()
                    if result == .alertSecondButtonReturn {
                        if let runningApp = process.runningApp {
                            runningApp.terminate()
                        } else {
                            shell("kill \(process.pid)")
                        }
                    }
                    if result == .alertThirdButtonReturn {
                        if let runningApp = process.runningApp {
                            runningApp.forceTerminate()
                        } else {
                            shell("kill -9 \(process.pid)")
                        }
                    }
                }
            }
            .frame(width: 60, alignment: .trailing)
        }
    }
}
