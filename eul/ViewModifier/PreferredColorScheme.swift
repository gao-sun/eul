//
//  PreferredColorScheme.swift
//  eul
//
//  Created by Gao Sun on 2021/3/18.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI

extension View {
    func preferredColorScheme() -> some View {
        modifier(PreferredColorScheme())
    }
}

struct PreferredColorScheme: ViewModifier {
    @EnvironmentObject var preferenceStore: PreferenceStore

    func body(content: Content) -> some View {
        if #available(OSX 11, *), let colorScheme = preferenceStore.appearanceMode.colorScheme {
            return AnyView(content.preferredColorScheme(colorScheme))
        }
        return AnyView(content)
    }
}
