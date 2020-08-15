//
//  ByteUnit.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

// edited from https://gist.github.com/fethica/52ef6d842604e416ccd57780c6dd28e6
public struct ByteUnit {
    public let bytes: UInt64

    public var kilobytes: Double {
        Double(bytes) / 1_024
    }

    public var megabytes: Double {
        kilobytes / 1_024
    }

    public var gigabytes: Double {
        megabytes / 1_024
    }

    public init(_ bytes: UInt64) {
        self.bytes = bytes
    }

    public init(_ bytes: Double) {
        self.bytes = UInt64(bytes)
    }

    public var readable: String {
        switch bytes {
        case 0..<1_024:
          return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
          return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
          return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...UInt64.max:
          return "\(String(format: "%.2f", gigabytes)) gb"
        default:
          return "\(bytes) bytes"
        }
    }
}
