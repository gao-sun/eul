//
//  StableWidth.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension View {
    func stableWidth(_ factor: CGFloat = 8, minWidth: CGFloat? = nil) -> some View {
        modifier(StableWidth(factor: factor, minWidth: minWidth))
    }
}

private struct CGFloatPreferenceKey: PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = []

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value += nextValue()
    }
}

struct StableWidth: ViewModifier {
    @State private var idealWidth: CGFloat?

    var factor: CGFloat
    var minWidth: CGFloat?

    var computedIdealWidth: CGFloat? {
        if let idealWidth = idealWidth {
            if let minWidth = minWidth {
                return max(idealWidth, minWidth)
            }
            return idealWidth
        }

        return nil
    }

    func getSize(_ proxy: GeometryProxy) -> some View {
        Color.clear.preference(
            key: CGFloatPreferenceKey.self,
            value: [factor * ceil(proxy.size.width / factor)]
        )
    }

    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
                .fixedSize()
                .background(GeometryReader { getSize($0) })
        }
        .frame(idealWidth: computedIdealWidth)
        .fixedSize()
        .onPreferenceChange(CGFloatPreferenceKey.self, perform: { value in
            idealWidth = value.first
        })
    }
}
