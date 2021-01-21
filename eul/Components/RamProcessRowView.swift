//
//  RamProcessRowView.swift
//  eul
//
//  Created by Jevon Mao on 1/18/21.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct RamProcessRowView: View {
    let section: String
    let process: RamUsage
    var nameWidth: CGFloat = 200
    var valueViewBuilder: (() -> AnyView)? = nil

    func doubleToStringSingleDigit(for number: Double) -> String {
        return String(format: "%.1f", number)
    }

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
                let percentage = process.percentage

                HStack {
                    Text("\(ByteUnit(process.usageAmount).readable)")
                        .displayText()
                        .frame(alignment: .trailing)
                    Text(doubleToStringSingleDigit(for: percentage))
                        .displayText()
                        .frame(width: 35, alignment: .trailing)
                }
            }
            HStack(spacing: 6) {
                if let runningApp = process.runningApp, runningApp.canBeActivated {
                    MenuActionButtonView(id: "\(section)-\(process.pid)-nagivate", imageName: "Navigate", toolTip: "process.bring_to_front") {
                        if runningApp.isActive {
                            NotificationCenter.default.post(name: .StatusBarMenuShouldClose, object: nil)
                        } else {
                            _ = runningApp.activate(options: .activateIgnoringOtherApps)
                        }
                    }
                }
                MenuActionButtonView(id: "\(section)-\(process.pid)-open", imageName: "Folder", toolTip: "process.reveal_in_finder") {
                    NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: process.command, isDirectory: false)])
                }
                MenuActionButtonView(id: "\(section)-\(process.pid)-terminate", imageName: "Terminate", toolTip: "process.terminate") {
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
