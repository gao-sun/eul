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
        Double(bytes) / 1024
    }

    public var megabytes: Double {
        kilobytes / 1024
    }

    public var gigabytes: Double {
        megabytes / 1024
    }

    public init(_ bytes: UInt64) {
        self.bytes = bytes
    }

    public init(_ bytes: Double) {
        self.bytes = UInt64(bytes)
    }

    public var readable: String {
        switch bytes {
        case 0..<(1024 * 1024):
            return "\(String(format: "%.\(kilobytes >= 100 ? 0 : 1)f", kilobytes)) KB"
        case 1024..<(1024 * 1024 * 1024):
            return "\(String(format: "%.\(megabytes >= 100 ? 0 : 1)f", megabytes)) MB"
        case (1024 * 1024 * 1024)...UInt64.max:
            return "\(String(format: "%.\(gigabytes >= 100 ? 0 : 1)f", gigabytes)) GB"
        default:
            return "\(bytes) Bytes"
        }
    }
}
