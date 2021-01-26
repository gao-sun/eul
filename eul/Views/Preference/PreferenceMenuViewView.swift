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
        private let coordinateSpace = "MenuComponentsOrdering"
        @EnvironmentObject var preference: PreferenceStore
        @EnvironmentObject var componentsStore: ComponentsStore<EulMenuComponent>
        @State var dragging: EulMenuComponent?
        @State var frames: [CGRect] = .init(repeating: .zero, count: EulMenuComponent.allCases.count)
        @GestureState var offsetHeight: CGFloat = 0

        func updateFrame(geometry: GeometryProxy, index: Int) -> some View {
            Color.clear.preference(
                key: FramePreferenceKey.self,
                value: componentsStore.isActiveComponentToggling
                    ? []
                    : [FramePreferenceData(index: index, frame: geometry.frame(in: CoordinateSpace.named(coordinateSpace)))]
            )
        }

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    Toggle(isOn: $preference.showCPUTopActivities) {
                        Text("menu.show_cpu_top_activities".localized())
                            .inlineSection()
                    }
                    Toggle(isOn: $preference.showRAMTopActivities) {
                        Text("menu.show_ram_top_activities".localized())
                            .inlineSection()
                    }
                    Toggle(isOn: $preference.showNetworkTopActivities) {
                        Text("menu.show_network_top_activities".localized())
                            .inlineSection()
                    }
                }
                .fixedSize()
                HStack(spacing: 12) {
                    Picker("cpu_display_mode".localized(), selection: $preference.cpuMenuDisplay) {
                        ForEach(Preference.CpuMenuDisplay.allCases, id: \.self) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    .frame(width: 250)
                }
                .fixedSize()
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("ui.menu_view".localized())
                                .subsection()
                            Text("component.drag_to_reorder".localized())
                                .subsection()
                                .foregroundColor(Color.gray)
                        }
                        .fixedSize()
                        VStack(spacing: 4) {
                            if componentsStore.activeComponents.isEmpty {
                                HStack {
                                    Spacer()
                                    Text("ui.empty".localized())
                                        .secondaryDisplayText()
                                    Spacer()
                                }
                            }
                            ForEach(Array(componentsStore.activeComponents.enumerated()), id: \.element) { offset, element in
                                HStack(spacing: 8) {
                                    Image(element.rawValue)
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text(element.localizedDescription)
                                        .normal()
                                        .fixedSize()
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
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.controlBackground)
                                .cornerRadius(4)
                                .offset(y: self.dragging == element ? self.offsetHeight : 0)
                                .zIndex(self.dragging == element ? 1 : 0)
                                .contentShape(Rectangle())
                                .gesture(DragGesture()
                                    .updating(self.$offsetHeight, body: { value, state, _ in
                                        state = value.translation.height

                                        let currentFrame = self.frames[offset]

                                        if state > 0, offset < self.componentsStore.activeComponents.count - 1 {
                                            let nextFrame = self.frames[offset + 1]

                                            if currentFrame.maxY + state > (nextFrame.minY + nextFrame.maxY) / 2 {
                                                DispatchQueue.main.async {
                                                    self.componentsStore.activeComponents.swapAt(offset, offset + 1)
                                                }
                                            }
                                        }

                                        if state < 0, offset > 0 {
                                            let prevFrame = self.frames[offset - 1]

                                            if currentFrame.minY + state < (prevFrame.minY + prevFrame.maxY) / 2 {
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
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.border, lineWidth: 1)
                        )
                        .clipped()
                        .coordinateSpace(name: coordinateSpace)
                        .frame(maxWidth: 180)
                    }
                    if componentsStore.availableComponents.count > 0 {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("component.available".localized())
                                    .subsection()
                                Text("component.click_to_append".localized())
                                    .subsection()
                                    .foregroundColor(Color.gray)
                            }
                            .fixedSize()
                            VStack(spacing: 4) {
                                ForEach(Array(componentsStore.availableComponents.enumerated()), id: \.element) { offset, element in
                                    HStack(spacing: 8) {
                                        Image(element.rawValue)
                                            .resizable()
                                            .frame(width: 12, height: 12)
                                        Text(element.localizedDescription)
                                            .normal()
                                            .fixedSize()
                                        Spacer()
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.controlBackground)
                                    .cornerRadius(4)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.fast) {
                                            self.componentsStore.toggleAvailableComponent(at: offset)
                                        }
                                    }
                                }
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .stroke(Color.border, lineWidth: 1)
                            )
                            .clipped()
                            .frame(maxWidth: 180)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .onPreferenceChange(FramePreferenceKey.self, perform: { value in
                for data in value {
                    self.frames[data.index] = data.frame
                }
            })
        }
    }
}
