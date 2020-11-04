//
//  Text.swift
//  eul
//
//  Created by Gao Sun on 2020/6/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Text {
    func compact(design: Font.Design = .default) -> some View {
        font(.system(size: 8, weight: .regular, design: design))
    }

    func normal(design: Font.Design = .default) -> some View {
        font(.system(size: 12, weight: .regular, design: design))
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

    func miniSection() -> some View {
        font(.system(size: 10, weight: .regular))
            .foregroundColor(.secondary)
    }

    func displayText() -> some View {
        font(.system(size: 11, weight: .regular))
    }

    func secondaryDisplayText() -> some View {
        font(.system(size: 11, weight: .regular))
            .foregroundColor(.secondary)
    }

    func menuSection() -> some View {
        font(.system(size: 12, weight: .bold))
            .padding(.top, 4)
            .padding(.bottom, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func widgetTitle() -> some View {
        font(.system(size: 40, weight: .heavy))
    }
}
