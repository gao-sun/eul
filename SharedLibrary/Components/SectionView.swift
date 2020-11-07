//
//  SectionView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct SectionView<Content: View>: View {
    public init(title: String, content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public let title: String
    public let content: () -> Content

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .section()
            content()
        }
    }
}
