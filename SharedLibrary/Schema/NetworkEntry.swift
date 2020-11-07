//
//  NetworkEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct NetworkEntry: SharedWidgetEntry {
    public init(date: Date = Date(), outdated: Bool = false, inSpeedInByte: Double = 0, outSpeedInByte: Double = 0) {
        self.date = date
        self.outdated = outdated
        self.inSpeedInByte = inSpeedInByte
        self.outSpeedInByte = outSpeedInByte
    }

    public init(date: Date, outdated: Bool) {
        self.date = date
        self.outdated = outdated
    }

    public static let containerKey = "NetworkEntry"
    public static let kind = "NetworkWidget"
    public static let sample = NetworkEntry(inSpeedInByte: 20480, outSpeedInByte: 10240)

    public var date = Date()
    public var outdated = false
    public var inSpeedInByte: Double = 0
    public var outSpeedInByte: Double = 0
}
