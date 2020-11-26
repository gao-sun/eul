//
//  Dict.swift
//  eul
//
//  Created by Gao Sun on 2020/11/23.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

struct Dict<Key, Value> where Key: Hashable {
    let buildDefault: (Key) -> Value
    var dict = [Key: Value]()

    init(buildDefault build: @escaping (Key) -> Value) {
        buildDefault = build
    }

    subscript(_ key: Key) -> Value {
        get {
            if let value = dict[key] {
                return value
            }
            return buildDefault(key)
        }

        set {
            dict[key] = newValue
        }
    }
}
