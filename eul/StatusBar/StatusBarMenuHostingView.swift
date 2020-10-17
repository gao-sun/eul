//
//  StatusBarMenuHostingView.swift
//  eul
//
//  Created by Gao Sun on 2020/10/17.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import SwiftUI

class StatusBarMenuHostingView<Content: View>: NSHostingView<Content> {
    // https://stackoverflow.com/a/2437435/12514940
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        window?.becomeKey()
    }
}
