//
//  NetworkTopStore.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import AppKit
import Combine
import SwiftUI

class NetworkTopStore: ObservableObject {
    struct NetworkSpeed: CustomStringConvertible {
        var inSpeedInByte: Double = 0
        var outSpeedInByte: Double = 0

        var totalSpeedInByte: Double {
            inSpeedInByte + outSpeedInByte
        }

        var description: String {
            fatalError("not implemented")
        }
    }

    struct ProcessNetworkUsage: ProcessUsage {
        typealias T = NetworkSpeed
        let pid: Int
        let command: String
        let value: NetworkSpeed
        let runningApp: NSRunningApplication?
    }

    static let shared = NetworkTopStore()

    private var task: Process?
    private var activeCancellable: AnyCancellable?
    private var lastTimestamp: TimeInterval = Date().timeIntervalSince1970
    private var lastInBytes: [Int: Double] = [:]
    private var lastOutBytes: [Int: Double] = [:]
    @ObservedObject var preferenceStore = PreferenceStore.shared
    @Published var processes: [ProcessNetworkUsage] = []

    var totalSpeed: NetworkSpeed {
        processes.reduce(into: NetworkSpeed()) { result, usage in
            result.inSpeedInByte += usage.value.inSpeedInByte
            result.outSpeedInByte += usage.value.outSpeedInByte
        }
    }

    var interval: Int {
        preferenceStore.networkRefreshRate
    }

    func update(shouldStart: Bool) {
        guard shouldStart else {
            task?.terminate()
            task = nil
            return
        }

        if task != nil {
            print("network task already started")
            return
        }

        lastInBytes.removeAll()
        lastOutBytes.removeAll()
        lastTimestamp = Date().timeIntervalSince1970
        processes = []
        task = shellPipe("nettop -P -x -J bytes_in,bytes_out -L0 -s \(interval)") { [self] string in
            let rows = string.split(separator: "\n").map { String($0) }
            let headers = rows[0]
                .split(separator: ",", omittingEmptySubsequences: false)
                .map { String($0.lowercased()) }
            let processIndex = 1

            guard
                let inBytesIndex = headers.firstIndex(of: "bytes_in"),
                let outBytesIndex = headers.firstIndex(of: "bytes_out")
            else {
                return
            }

            let runningApps = NSWorkspace.shared.runningApplications
            let time = Date().timeIntervalSince1970
            let timeElapsed = time - lastTimestamp

            processes = rows.dropFirst().compactMap { row in
                let cols = row.split(separator: ",").map { String($0) }

                guard
                    cols.indices.contains(processIndex),
                    cols.indices.contains(inBytesIndex),
                    cols.indices.contains(outBytesIndex)
                else {
                    return nil
                }

                let processCol = cols[processIndex]
                let splitted = processCol.split(separator: ".").map { String($0) }

                guard
                    let last = splitted.last,
                    let pid = Int(last),
                    let inBytes = Double(cols[inBytesIndex]),
                    let outBytes = Double(cols[outBytesIndex])
                else {
                    return nil
                }

                let lastIn = lastInBytes[pid]
                let lastOut = lastOutBytes[pid]

                lastInBytes[pid] = inBytes
                lastOutBytes[pid] = outBytes

                if lastIn == nil, lastOut == nil {
                    return nil
                }

                let speed = NetworkSpeed(
                    inSpeedInByte: lastIn.map { (inBytes - $0) / timeElapsed } ?? 0,
                    outSpeedInByte: lastOut.map { (outBytes - $0) / timeElapsed } ?? 0
                )

                guard speed.totalSpeedInByte > 0.1 else {
                    return nil
                }

                return ProcessNetworkUsage(
                    pid: pid,
                    command: Info.getProcessCommand(pid: pid) ?? splitted[0],
                    value: speed,
                    runningApp: runningApps.first(where: { $0.processIdentifier == pid })
                )
            }
            .sorted(by: { $0.value.totalSpeedInByte > $1.value.totalSpeedInByte })

            lastTimestamp = time
        }
    }

    init() {
        update(shouldStart: preferenceStore.showTopActivities)
        activeCancellable = preferenceStore.$showTopActivities.sink { [self] in
            update(shouldStart: $0)
        }
    }
}
