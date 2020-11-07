//
//  NetworkEntry.swift
//  SharedLibrary
//
//  Created by Gao Sun on 2020/11/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public struct NetworkEntry: SharedWidgetEntry {
    public init(date: Date = Date(), inSpeedInByte: Double = 0, outSpeedInByte: Double = 0, isValid: Bool = true) {
        self.date = date
        self.inSpeedInByte = inSpeedInByte
        self.outSpeedInByte = outSpeedInByte
        self.isValid = isValid
    }

    public init(date: Date, isValid: Bool) {
        self.date = date
        self.isValid = isValid
    }

    public static let containerKey = "NetworkEntry"
    public static let kind = "NetworkWidget"
    public static let sample = NetworkEntry(inSpeedInByte: 20480, outSpeedInByte: 10240)

    public var date = Date()
    public var inSpeedInByte: Double = 0
    public var outSpeedInByte: Double = 0
    public var isValid: Bool = true
}
