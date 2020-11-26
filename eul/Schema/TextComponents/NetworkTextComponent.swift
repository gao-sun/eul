//
//  NetworkTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/11/26.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

enum NetworkTextComponent: String, CaseIterable, JSONCodabble, LocalizedTextComponent {
    case upload
    case download
}
