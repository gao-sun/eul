//
//  SharedEntry.swift
//  eul
//
//  Created by Gao Sun on 2020/11/5.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import WidgetKit

public protocol SharedEntry: Codable {
    static var containerKey: String { get }
}
