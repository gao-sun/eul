//
//  ActivityIndicatorView.swift
//  eul
//
//  Created by Gao Sun on 2020/9/13.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

public struct ActivityIndicatorView: NSViewRepresentable {
    public init(configuration: @escaping (ActivityIndicatorView.NSViewType) -> Void = { (_: NSViewType) in }) {
        self.configuration = configuration
    }

    public typealias NSViewType = NSProgressIndicator
    public var configuration = { (_: NSViewType) in }

    public func makeNSView(context _: NSViewRepresentableContext<ActivityIndicatorView>) -> NSProgressIndicator {
        NSViewType()
    }

    public func updateNSView(_ nsView: NSProgressIndicator, context _: NSViewRepresentableContext<ActivityIndicatorView>) {
        configuration(nsView)
    }
}
