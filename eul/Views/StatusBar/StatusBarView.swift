//
//  StatusBarView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/20.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusBarView: SizeChangeView {
    @EnvironmentObject var preferenceStore: PreferenceStore
    @EnvironmentObject var componentsStore: ComponentsStore<EulComponent>
    var onSizeChange: ((CGSize) -> Void)?

    var spacing: CGFloat {
        preferenceStore.fontDesign == .default ? 10 : 8
    }

    var body: some View {
        HStack(spacing: spacing) {
            if componentsStore.showComponents {
                ForEach(componentsStore.activeComponents) { component in
                    component.getView()
                }
            } else {
                Image("eul")
                    .resizable()
                    .frame(width: 16, height: 16)
            }
        }
        .fixedSize()
        .background(GeometryReader { self.reportSize($0) })
    }
}
