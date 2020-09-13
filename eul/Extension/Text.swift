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
        font(.system(size: 8, weight: .regular))
    }

    func normal() -> some View {
        font(.system(size: 12, weight: .regular))
    }

    func section() -> some View {
        font(.headline)
            .padding(.top, 8)
            .padding(.bottom, 4)
    }

    func subsection() -> some View {
        font(.system(size: 12, weight: .regular))
            .padding(.top, 8)
    }

    func inlineSection() -> some View {
        font(.system(size: 12, weight: .regular))
    }

    func menuSection() -> some View {
        font(.system(size: 11, weight: .semibold))
            .padding(.top, 8)
            .padding(.bottom, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
