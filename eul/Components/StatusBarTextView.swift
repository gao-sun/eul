//
//  StatusBarTextView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/12.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct StatusBarTextView: View {
    @ObservedObject var preferenceStore = SharedStore.preference
    var texts: [String] = []
    var alignment: HorizontalAlignment = .trailing

    var fontDesign: Font.Design {
        preferenceStore.fontDesign.value
    }

    func getCompactRow(_ index: Int) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(self.texts[index * 2])
                .compact(design: fontDesign)
            Text(self.texts[index * 2 + 1])
                .compact(design: fontDesign)
        }
    }

    var body: some View {
        HStack {
            if preferenceStore.textDisplay == .singleLine {
                ForEach(0..<texts.count, id: \.self) {
                    Text(self.texts[$0])
                        .normal(design: self.fontDesign)
                }
            }

            if preferenceStore.textDisplay == .compact {
                ForEach(0..<(texts.count / 2), id: \.self) {
                    self.getCompactRow($0)
                }
                if texts.count % 2 == 1 {
                    Text(texts[texts.count - 1])
                        .normal(design: fontDesign)
                }
            }
        }
    }
}
