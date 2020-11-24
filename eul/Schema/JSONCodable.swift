//
//  JSONCodable.swift
//  eul
//
//  Created by Gao Sun on 2020/11/24.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftyJSON

protocol JSONCodabble {
    init?(json: JSON)

    var json: JSON { get }
}

extension JSONCodabble where Self: RawRepresentable, Self.RawValue == String {
    var json: JSON {
        JSON(rawValue)
    }

    init?(json: JSON) {
        guard let string = json.string else {
            return nil
        }
        self.init(rawValue: string)
    }
}
