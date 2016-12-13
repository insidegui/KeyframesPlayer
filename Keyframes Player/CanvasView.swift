//
//  CanvasView.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa

class CanvasView: NSView {

    var target: Any?
    var action: Selector?
    
    override var isFlipped: Bool {
        return true
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func mouseUp(with event: NSEvent) {
        if event.clickCount == 1 {
            if let action = self.action {
                NSApp.sendAction(action, to: target, from: self)
            }
        } else {
            super.mouseUp(with: event)
        }
    }
    
}
