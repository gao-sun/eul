//
//  SizePreferenceKey.swift
//  eul
//
//  Created by Gao Sun on 2020/11/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    typealias Value = [CGSize]

    static var defaultValue: [CGSize] = []

    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value += nextValue()
    }
}
