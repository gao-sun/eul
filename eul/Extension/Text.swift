//
//  Text.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Text {
    func compact() -> some View {
        self
            .font(.system(size: 8, weight: .regular))
    }

    func normal() -> some View {
        self
            .font(.system(size: 12, weight: .regular))
    }

    func section() -> some View {
        self
            .font(.headline)
            .padding(.vertical, 8)
    }

    func subsection() -> some View {
        self
            .font(.system(size: 12, weight: .regular))
            .padding(.vertical, 4)
    }
}
