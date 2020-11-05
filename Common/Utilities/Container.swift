//
//  Container.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

enum Container {
    static let defaults = UserDefaults(suiteName: "com.gaosun.eul.shared")
    static let pListEncoder = PropertyListEncoder()
    static let pListDecoder = PropertyListDecoder()

    static func get<T: SharedEntry>(_ type: T.Type) -> T? {
        if let data = defaults?.data(forKey: T.containerKey), let decoded = try? pListDecoder.decode(type, from: data) {
            return decoded
        }
        return nil
    }

    static func set<T: SharedEntry>(_ value: T?) {
        if let value = value, let encoded = try? pListEncoder.encode(value) {
            defaults?.setValue(encoded, forKey: T.containerKey)
        }
    }
}
