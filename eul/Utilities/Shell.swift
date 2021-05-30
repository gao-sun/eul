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
func shellData(_ args: [String]) -> Data? {
    let task = Process()
    let pipe = Pipe()
    let error = Pipe()

    Print("shell with", args)

    task.standardOutput = pipe
    task.standardError = error
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = ["-c"] + args
    task.environment = ["LC_ALL": "en_US.UTF-8"]

    do {
        try task.run()
    } catch {
        print("⚠️ shell executed with error", error)
    }

    let data = pipe.fileHandleForReading.readDataToEndOfFile()

    task.waitUntilExit()

    if task.terminationStatus != 0 {
        return nil
    }

    return data
}

@discardableResult
func shell(_ args: String...) -> String? {
    guard let data = shellData(args) else {
        return nil
    }

    return String(data: data, encoding: .utf8)
}

func shellAsync(_ args: String..., onFinish: @escaping (String?) -> Void) {
    DispatchQueue.global().async {
        guard let data = shellData(args) else {
            onFinish(nil)
            return
        }

        onFinish(String(data: data, encoding: .utf8))
    }
}

@discardableResult
func shellPipe(_ args: String..., onData: ((String) -> Void)? = nil, didTerminate: (() -> Void)? = nil) -> Process {
    let task = Process()
    let pipe = Pipe()

    Print("shell pipe with", args)

    task.standardOutput = pipe
    task.executableURL = URL(fileURLWithPath: "/bin/bash")
    task.arguments = ["-c"] + args
    task.environment = ["LC_ALL": "en_US.UTF-8"]

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
        do {
            try task.run()
        } catch {
            print("⚠️ shell pipe executed with error", error)
        }
    }

    return task
}
