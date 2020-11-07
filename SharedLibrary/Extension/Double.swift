//
//  Double.swift
//  eul
//
//  Created by Gao Sun on 2020/9/16.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

public extension Double {
    var percentageString: String {
        (isNaN || isInfinite) ? "N/A" : String(format: "%.0f%%", self * 100)
    }
}
