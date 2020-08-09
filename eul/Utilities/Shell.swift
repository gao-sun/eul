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

    if (task.terminationStatus != 0) {
        return nil
    }

    return output
}
