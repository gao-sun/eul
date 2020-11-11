//
//  FramePreferenceKey.swift
//  eul
//
//  Created by Gao Sun on 2020/11/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct FramePreferenceData: Equatable {
    let index: Int
    let frame: CGRect
}

struct FramePreferenceKey: PreferenceKey {
    typealias Value = [FramePreferenceData]

    static var defaultValue: [FramePreferenceData] = []

    static func reduce(value: inout [FramePreferenceData], nextValue: () -> [FramePreferenceData]) {
        value += nextValue()
    }
}
