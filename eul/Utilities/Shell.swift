//
//  Shell.swift
//  eul
//
//  Created by Gao Sun on 2020/8/9.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
@discardableResult
func shell(_ args: String...) -> String? {
    let task = Process()
    let pipe = Pipe()
    let error = Pipe()

    task.standardOutput = pipe
    task.standardError = error
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"] + args
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)

    task.waitUntilExit()

    if task.terminationStatus != 0 {
        return nil
    }

    return output
}

@discardableResult
func shellPipe(_ args: String..., onData: ((String) -> Void)? = nil, didTerminate: (() -> Void)? = nil) -> Process {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"] + args

    let outHandle = pipe.fileHandleForReading
    outHandle.waitForDataInBackgroundAndNotify()

    var progressObserver: NSObjectProtocol!
    progressObserver = NotificationCenter.default.addObserver(
        forName: NSNotification.Name.NSFileHandleDataAvailable,
        object: outHandle,
        queue: nil
    ) { _ in
        let data = outHandle.availableData

        if data.count > 0 {
            if let str = String(data: data, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async {
                    onData?(str)
                }
            }
            outHandle.waitForDataInBackgroundAndNotify()
        } else {
            DispatchQueue.main.async {
                didTerminate?()
            }
            NotificationCenter.default.removeObserver(progressObserver!)
        }
    }

    var terminationObserver: NSObjectProtocol!
    terminationObserver = NotificationCenter.default.addObserver(
        forName: Process.didTerminateNotification,
        object: task, queue: nil
    ) {
        _ -> Void in
        DispatchQueue.main.async {
            didTerminate?()
        }
        NotificationCenter.default.removeObserver(terminationObserver!)
    }

    DispatchQueue(label: "shellPipe-\(UUID().uuidString)", qos: .background).async {
        task.launch()
    }

    return task
}
