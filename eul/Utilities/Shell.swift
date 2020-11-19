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

    Print("shell with", args)

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

    Print("shell pipe with", args)

    task.standardOutput = pipe
    task.launchPath = "/bin/bash"
    task.arguments = ["-c"] + args

    var buffer = Data()
    let outHandle = pipe.fileHandleForReading
    outHandle.readabilityHandler = { _ in
        let data = outHandle.availableData

        Print("data received for", args)

        if data.count > 0 {
            buffer += data
            if let str = String(data: buffer, encoding: String.Encoding.utf8), str.last?.isNewline == true {
                buffer.removeAll()
                onData?(str)
            }
            outHandle.waitForDataInBackgroundAndNotify()
        } else {
            buffer.removeAll()
        }
    }
    outHandle.waitForDataInBackgroundAndNotify()

    task.terminationHandler = { _ in
        try? outHandle.close()
        didTerminate?()
    }

    DispatchQueue(label: "shellPipe-\(UUID().uuidString)", qos: .background, attributes: .concurrent).async {
        Print("good to launch")
        task.launch()
    }

    return task
}
