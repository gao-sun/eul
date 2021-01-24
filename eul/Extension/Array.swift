//
//  Array.swift
//  eul
//
//  Created by Gao Sun on 2020/12/2.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

extension Array {
    func appending(_ newElement: Element, condition: Bool = true) -> [Element] {
        condition ? self + [newElement] : self
    }

    func appending(_ newElements: [Element], condition: Bool = true) -> [Element] {
        condition ? self + newElements : self
    }
}
