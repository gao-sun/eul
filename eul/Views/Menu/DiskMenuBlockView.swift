//
//  DiskMenuBlockView.swift
//  eul
//
//  Created by Gao Sun on 2021/1/23.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SharedLibrary
import SwiftUI

struct DiskRowView: View {
    @EnvironmentObject var diskStore: DiskStore
    @State var isEjecting = false

    var disk: DiskList.Disk

    func refresh() {
        isEjecting = false
        diskStore.refresh()
    }

    var body: some View {
        HStack {
            Text(disk.name)
                .secondaryDisplayText()
                .lineLimit(1)
            if disk.isEjectable {
                if isEjecting {
                    ActivityIndicatorView {
                        $0.style = .spinning
                        $0.controlSize = .mini
                        $0.startAnimation(nil)
                    }
                } else {
                    MenuActionButtonView(
                        id: "disk-\(disk.name)-eject",
                        imageName: "Eject",
                        toolTip: "disk.eject"
                    ) {
                        isEjecting = true
                        DispatchQueue.global().async {
                            do {
                                try NSWorkspace.shared.unmountAndEjectDevice(at: URL(fileURLWithPath: disk.path, isDirectory: true))
                            } catch {
                                DispatchQueue.main.async {
                                    let alert = NSAlert()
                                    alert.messageText = error.localizedDescription
                                    alert.alertStyle = .informational

                                    NSApp.activate(ignoringOtherApps: true)
                                    alert.runModal()
                                }
                            }
                            DispatchQueue.main.async {
                                refresh()
                            }
                        }
                    }
                }
            }
            Spacer()
            MenuInfoView(label: "U", text: disk.usedSizeString)
            MenuInfoView(label: "F", text: disk.freeSizeString)
        }
    }
}

struct DiskMenuBlockView: View {
    @EnvironmentObject var diskStore: DiskStore

    var body: some View {
        VStack(spacing: 8) {
            Text("component.disk".localized())
                .menuSection()
            if let list = diskStore.list {
                ForEach(list.disks) {
                    DiskRowView(disk: $0)
                }
            } else {
                Text("N/A".localized())
                    .placeholder()
                    .padding(.bottom, 4)
            }
        }
        .padding(.top, 2)
        .menuBlock()
    }
}
