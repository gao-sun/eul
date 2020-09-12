//
//  View.swift
//  eul
//
//  Created by Gao Sun on 2020/9/11.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension View {
    func menuInfo() -> some View {
        self
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.info)
            .padding(.leading, 20)
            .padding(.trailing, 12)
            .padding(.top, -2)
            .padding(.bottom, 4)
            .fixedSize()
    }
}
