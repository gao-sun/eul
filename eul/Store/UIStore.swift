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
    static let shared = UIStore()

    @Published var hoveringID: String?
}
