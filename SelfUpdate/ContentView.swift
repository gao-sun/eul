//
//  ContentView.swift
//  SelfUpdate
//
//  Created by Gao Sun on 2021/2/12.
//  Copyright © 2021 Gao Sun. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ForEach(CommandLine.arguments, id: \.self) {
                Text($0)
            }
        }
    }
}
