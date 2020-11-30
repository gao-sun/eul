//
//  Collection.swift
//  eul
//
//  Created by Gao Sun on 2020/11/28.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
