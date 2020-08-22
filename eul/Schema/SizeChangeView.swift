//
//  SizeChangeView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/21.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

typealias SizeChange = ((CGSize) -> Void)?

protocol SizeChangeView: View {
    var onSizeChange: SizeChange { get }
    func reportSize(_ geometry: GeometryProxy) -> Color
}

extension SizeChangeView {
    func reportSize(_ geometry: GeometryProxy) -> Color {
        onSizeChange?(geometry.size)
        return Color.clear
    }
}
