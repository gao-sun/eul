//
//  PreferenceComponentsView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct ComponentsView: View {
        private let coordinateSpace = "ComponentsOrdering"
        @EnvironmentObject var preference: PreferenceStore
        @EnvironmentObject var componentsStore: ComponentsStore<EulComponent>
        @State var dragging: EulComponent?
        @State var frames: [CGRect] = .init(repeating: .zero, count: EulComponent.allCases.count)
        @GestureState var offsetWidth: CGFloat = 0

        func updateFrame(geometry: GeometryProxy, index: Int) -> some View {
            if !componentsStore.isActiveComponentToggling {
                DispatchQueue.main.async {
                    self.frames[index] = geometry.frame(in: CoordinateSpace.named(coordinateSpace))
                }
            }
            return Color.clear
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 12) {
                    Toggle(isOn: $componentsStore.showComponents) {
                        Text("ui.show_components_in_status_bar".localized())
                            .inlineSection()
                    }
                    if componentsStore.showComponents {
                        Toggle(isOn: $preference.showIcon) {
                            Text("ui.show_icon".localized())
                                .inlineSection()
                        }
                    }
                    Spacer()
                }
                if componentsStore.showComponents {
                    HStack {
                        Text("component.status_bar".localized())
                            .subsection()
                        Text("component.drag_to_reorder".localized())
                            .subsection()
                            .foregroundColor(Color.gray)
                    }
                    HStack {
                        ForEach(Array(componentsStore.activeComponents.enumerated()), id: \.element) { offset, element in
                            HStack(spacing: 8) {
                                Image(element.rawValue)
                                    .resizable()
                                    .frame(width: 12, height: 12)
                                Text(element.localizedDescription)
                                    .normal()
                                if self.componentsStore.activeComponents.count > 1 {
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
                            .padding(.vertical, 4)
                            .padding(.horizontal, 12)
                            .background(Color.controlBackground)
                            .cornerRadius(4)
                            .offset(x: self.dragging == element ? self.offsetWidth : 0)
                            .zIndex(self.dragging == element ? 1 : 0)
                            .contentShape(Rectangle())
                            .fixedSize()
                            .gesture(DragGesture()
                                .updating(self.$offsetWidth, body: { value, state, _ in
                                    state = value.translation.width

                                    let currentFrame = self.frames[offset]

                                    if state > 0, offset < self.componentsStore.activeComponents.count - 1 {
                                        let nextFrame = self.frames[offset + 1]

                                        if currentFrame.maxX + state > (nextFrame.minX + nextFrame.maxX) / 2 {
                                            DispatchQueue.main.async {
                                                self.componentsStore.activeComponents.swapAt(offset, offset + 1)
                                            }
                                        }
                                    }

                                    if state < 0, offset > 0 {
                                        let prevFrame = self.frames[offset - 1]

                                        if currentFrame.minX + state < (prevFrame.minX + prevFrame.maxX) / 2 {
                                            DispatchQueue.main.async {
                                                self.componentsStore.activeComponents.swapAt(offset, offset - 1)
                                            }
                                        }
                                    }
                                })
                                .onChanged { _ in
                                    self.dragging = element
                                }
                                .onEnded { _ in
                                    self.dragging = nil
                                }
                            )
                            .background(GeometryReader { geometry in
                                self.updateFrame(geometry: geometry, index: offset)
                            })
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.border, lineWidth: 1)
                    )
                    .clipped()
                    .coordinateSpace(name: coordinateSpace)
                    if componentsStore.availableComponents.count > 0 {
                        HStack {
                            Text("component.available".localized())
                                .subsection()
                            Text("component.click_to_append".localized())
                                .subsection()
                                .foregroundColor(Color.gray)
                        }
                        HStack {
                            ForEach(Array(componentsStore.availableComponents.enumerated()), id: \.element) { offset, element in
                                HStack(spacing: 8) {
                                    Image(element.rawValue)
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text(element.localizedDescription)
                                        .normal()
                                }
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(Color.controlBackground)
                                .cornerRadius(4)
                                .contentShape(Rectangle())
                                .fixedSize()
                                .onTapGesture {
                                    withAnimation(.fast) {
                                        self.componentsStore.toggleAvailableComponent(at: offset)
                                    }
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
                    }
                }
            }
        }
    }
}
