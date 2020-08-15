//
//  PreferenceDisplayView.swift
//  eul
//
//  Created by Gao Sun on 2020/8/15.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

extension Preference {
    struct DisplayView: View {
        let temperatureUnits = TemperatureUnit.allCases

        @EnvironmentObject var preference: PreferenceStore

        var body: some View {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text("Temperature")
                        .inlineSection()
                    Picker("", selection: $preference.temperatureUnit) {
                        ForEach(temperatureUnits) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .frame(width: 120)
                }
            }
        }
    }
}
