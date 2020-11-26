//
//  LocalizedStringConvertible.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

protocol LocalizedStringConvertible {
    var localizedDescription: String { get }
}

protocol LocalizedTextComponent: LocalizedStringConvertible, RawRepresentable where RawValue == String {}

extension LocalizedTextComponent {
    var localizedDescription: String {
        "text_component.\(rawValue)".localized()
    }
}
