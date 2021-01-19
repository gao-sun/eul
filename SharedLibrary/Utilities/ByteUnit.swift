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
    public let kilo: UInt64

    public var kilobytes: Double {
        Double(bytes) / Double(kilo)
    }

    public var megabytes: Double {
        kilobytes / Double(kilo)
    }

    public var gigabytes: Double {
        megabytes / Double(kilo)
    }

    public init(_ bytes: UInt64, kilo: UInt64 = 1024) {
        self.bytes = bytes
        self.kilo = kilo
    }

    public init(_ bytes: Double, kilo: UInt64 = 1024) {
        self.bytes = UInt64(bytes)
        self.kilo = kilo
    }

    public init(_ megaBytes: Double){
        self.bytes = UInt64(megaBytes*1000000)
        self.kilo = 1024
    }

    public var readable: String {
        switch bytes {
        case 0..<(kilo * kilo):
            return "\(String(format: "%.\(0)f", kilobytes)) KB"
        case kilo..<(kilo * kilo * kilo):
            return "\(String(format: "%.\(megabytes >= 100 ? 0 : 1)f", megabytes)) MB"
        case (kilo * kilo * kilo)...UInt64.max:
            return "\(String(format: "%.\(gigabytes >= 100 ? 0 : 1)f", gigabytes)) GB"
        default:
            return "\(bytes) Bytes"
        }
    }
}
