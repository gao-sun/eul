//
//  ActivityIndicatorView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/13.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

struct ActivityIndicatorView: NSViewRepresentable {
    typealias NSViewType = NSProgressIndicator
    var configuration = { (_: NSViewType) in }

    func makeNSView(context _: NSViewRepresentableContext<ActivityIndicatorView>) -> NSProgressIndicator {
        NSViewType()
    }

    func updateNSView(_ nsView: NSProgressIndicator, context _: NSViewRepresentableContext<ActivityIndicatorView>) {
        configuration(nsView)
    }
}
