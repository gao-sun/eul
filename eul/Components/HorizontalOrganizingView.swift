//
//  HorizontalOrganizingView.swift
//  eul
//
//  Created by Gao Sun on 2020/11/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct HorizontalOrganizingView<Element: JSONCodabble & Equatable & Hashable, ElementView: View>: View {
    @ObservedObject var componentsStore: ComponentsStore<Element>
    let coordinateSpace: String
    var buildElementView: (Element) -> ElementView

    @State var dragging: Element?
    @State var frames: [CGRect]
    @GestureState var offsetWidth: CGFloat = 0

    func updateFrame(geometry: GeometryProxy, index: Int) -> some View {
        Color.clear.preference(
            key: FramePreferenceKey.self,
            value: componentsStore.isActiveComponentToggling
                ? []
                : [FramePreferenceData(index: index, frame: geometry.frame(in: CoordinateSpace.named(coordinateSpace)))]
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
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
                        buildElementView(element)
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
                            buildElementView(element)
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
        .onPreferenceChange(FramePreferenceKey.self, perform: { value in
            for data in value {
                self.frames[data.index] = data.frame
            }
        })
    }
}

extension HorizontalOrganizingView {
    init(componentsStore: ComponentsStore<Element>, count: Int, coordinateSpace: String, buildElementView: @escaping (Element) -> ElementView) {
        self.componentsStore = componentsStore
        _frames = State(initialValue: [CGRect](repeating: .zero, count: count))
        self.coordinateSpace = coordinateSpace
        self.buildElementView = buildElementView
    }
}
