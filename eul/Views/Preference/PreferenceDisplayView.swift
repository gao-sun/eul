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
        let temperatureUnits: [TemperatureUnit] = [.celius, .fahrenheit]
        let textDisplays = TextDisplay.allCases

        @EnvironmentObject var preference: PreferenceStore

        var body: some View {
            HStack(spacing: 24) {
                HStack(spacing: 0) {
                    Picker("Temperature", selection: $preference.temperatureUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    .frame(width: 200)
                }
                HStack(spacing: 0) {
                    Picker("Text Display", selection: $preference.textDisplay) {
                        ForEach(textDisplays) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    .frame(width: 200)
                }
            }
            .padding(.vertical, 8)
        }
    }
}
