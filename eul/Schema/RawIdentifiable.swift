//
//  RawIdentifiable.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

protocol StringEnum: CaseIterable, Identifiable, RawRepresentable where RawValue == String {
    var id: String { get }
    var description: String { get }
}

extension StringEnum {
    var id: String {
        rawValue
    }

    var description: String {
        rawValue.unicodeScalars.reduce("") {
            if CharacterSet.uppercaseLetters.contains($1) {
                if $0.count > 0 {
                    return ($0 + " " + String($1).lowercased())
                }
            }
            return $0 + String($1)
        }
    }
}
