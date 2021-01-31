//
//  EulComponentConfig.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SwiftyJSON

struct EulComponentConfig: Codable {
    var component: EulComponent
    var showIcon: Bool = true
    var showGraph: Bool = false
    var diskSelection: String = SharedStore.disk.list?.disks.first?.name ?? "N/A"

    var json: JSON {
        JSON([
            "component": component.rawValue,
            "showIcon": showIcon,
            "showGraph": showGraph,
            "diskSelection": diskSelection,
        ])
    }
}

extension EulComponentConfig {
    init?(_ json: JSON) {
        guard let rawComponent = json["component"].string, let component = EulComponent(rawValue: rawComponent) else {
            return nil
        }

        self.component = component

        if let bool = json["showIcon"].bool {
            showIcon = bool
        }

        if let bool = json["showGraph"].bool {
            showGraph = bool
        }

        if let string = json["diskSelection"].string {
            diskSelection = string
        }
    }
}
