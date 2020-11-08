//
//  EulComponentConfig.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation

protocol EulComponentConfig: Codable {
    var component: EulComponent { get }
    var showIcon: Bool { get }
    var graphAvailable: Bool { get }
    var showGraph: Bool { get }
}
