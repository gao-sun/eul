//
//  UIStore.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import AppKit
import Foundation

class UIStore: ObservableObject {
    @Published var hoveringID: String?
    @Published var menuWidth: CGFloat?
    @Published var menuOpened = false
    @Published var activeSection: Preference.Section = .general
}
