//
//  NetworkStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/9.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import WidgetKit

class NetworkStore: ObservableObject, Refreshable {
    private var networkUsageHasBeenSet = true
    private var lastTimestamp: TimeInterval

    @Published var networkUsage = Info.NetworkUsage(inBytes: 0, outBytes: 0)
    @Published var ports = [Info.NetworkPort]()
    @Published var currentActivePort: Info.NetworkPort?

    @Published var inSpeedInByte: Double = 0
    @Published var outSpeedInByte: Double = 0

    var config: EulComponentConfig {
        SharedStore.componentConfig[EulComponent.Network]
    }

    var inSpeed: String {
        ByteUnit(inSpeedInByte).readable + "/s"
    }

    var outSpeed: String {
        ByteUnit(outSpeedInByte).readable + "/s"
    }

    var autoPortDesscription: String {
        guard let currentActivePort = currentActivePort else {
            return "network.port.auto".localized()
        }

        return "\("network.port.auto".localized()) (\(currentActivePort.device))"
    }

    @objc func refresh() {
        guard networkUsageHasBeenSet else {
            return
        }

        networkUsageHasBeenSet = false

        Info.getNetworkUsage(forDevice: config.networkPortSelection.nilIfEmpty) { [self] current, ports, currentActivePort in
            let time = Date().timeIntervalSince1970

            if networkUsage.inBytes > 0, current.inBytes >= networkUsage.inBytes {
                inSpeedInByte = Double(current.inBytes - networkUsage.inBytes) / (time - lastTimestamp)
            } else {
                inSpeedInByte = 0
            }

            if networkUsage.outBytes > 0, current.outBytes >= networkUsage.outBytes {
                outSpeedInByte = Double(current.outBytes - networkUsage.outBytes) / (time - lastTimestamp)
            } else {
                outSpeedInByte = 0
            }

            lastTimestamp = time
            networkUsage = current
            self.ports = ports
            self.currentActivePort = currentActivePort
            writeToContainer()
            networkUsageHasBeenSet = true
        }
    }

    func writeToContainer() {
        Container.set(NetworkEntry(inSpeedInByte: inSpeedInByte, outSpeedInByte: outSpeedInByte))
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: NetworkEntry.kind)
        }
    }

    init() {
        lastTimestamp = Date().timeIntervalSince1970
        initObserver(for: .NetworkShouldRefresh)
    }
}
