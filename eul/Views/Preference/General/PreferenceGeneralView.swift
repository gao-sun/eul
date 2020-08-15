//
//  PreferenceGeneralView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct GeneralView: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("Display")
                    .section()
                DisplayView()
                Text("Components")
                    .section()
                ComponentsView()
            }
        }
    }
}
