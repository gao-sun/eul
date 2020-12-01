//
//  FanTextComponent.swift
//  eul
//
//  Created by Gao Sun on 2020/12/1.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct FanTextComponent: Hashable {
    var id: Int

    var isAverage: Bool {
        id == -1
    }
}

extension FanTextComponent: CaseIterable {
    static var allCases: [Self]
        = defaultComponents + [FanTextComponent(id: -1)]

    static var defaultComponents: [Self] {
        SmcControl.shared.fans.map { FanTextComponent(id: $0.id) }
    }
}

extension FanTextComponent: JSONCodabble {
    init?(json: JSON) {
        guard let id = json["id"].int else {
            return nil
        }
        self.id = id
    }

    var json: JSON {
        JSON([
            "id": id,
        ])
    }
}

extension FanTextComponent: LocalizedStringConvertible {
    var localizedDescription: String {
        id == -1 ? "text_component.average".localized() : "fan".localized() + " \(id + 1)"
    }
}
