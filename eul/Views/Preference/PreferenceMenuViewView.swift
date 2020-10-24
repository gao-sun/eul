//
//  PreferenceMenuViewView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/18.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct PreferenceMenuViewView: View {
        @EnvironmentObject var preference: PreferenceStore
        @EnvironmentObject var componentsStore: ComponentsStore<EulMenuComponent>
        @State var dragging: EulMenuComponent?

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Toggle(isOn: $preference.showTopActivities) {
                    Text("menu.show_top_activities".localized())
                        .inlineSection()
                }
                VStack {
                    ForEach(Array(componentsStore.activeComponents.enumerated()), id: \.element) { offset, element in
                        HStack(spacing: 8) {
                            Image(element.rawValue)
                                .resizable()
                                .frame(width: 12, height: 12)
                            Text(element.localizedDescription)
                                .normal()
                            Spacer()
                            Image("X")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .padding(.horizontal, 4)
                                .contentShape(Rectangle())
                                .foregroundColor(Color.gray)
                                .onHover {
                                    guard self.dragging == nil else {
                                        return
                                    }
                                    if $0 {
                                        NSCursor.pointingHand.push()
                                    } else {
                                        NSCursor.pop()
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.fast) {
                                        self.componentsStore.toggleActiveComponent(at: offset)
                                    }
                                }
                                .padding(.trailing, -4)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .stroke(Color.border, lineWidth: 1)
                )
                .clipped()
                .coordinateSpace(name: "MenuComponentsOrdering")
                .frame(maxWidth: 200)
            }
            .padding(.vertical, 8)
        }
    }
}
