//
//  Print.swift
//  eul
//
//  Created by Gao Sun on 2020/10/19.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

private let isDebug = CommandLine.arguments.contains(where: { $0 == "--debug" })

func Print(_ items: Any...) {
    if isDebug {
        for item in items {
            print(item, terminator: "")
            print(" ", terminator: "")
        }
        print("")
    }
}
