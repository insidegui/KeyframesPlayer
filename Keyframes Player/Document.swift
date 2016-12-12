//
//  Document.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa
import keyframes

class Document: NSDocument {

    enum DocumentError: Error {
        case load
    }
    
    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        self.addWindowController(windowController)
    }
    
    private func propagate(_ vector: KFVector) {
        windowControllers.forEach {
            if var vc = $0.contentViewController as? UsesVector {
                vc.vector = vector
            }
        }
    }

    override func read(from data: Data, ofType typeName: String) throws {
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let face = obj as? [AnyHashable: Any] else {
            throw DocumentError.load
        }
        
        guard let vector = KFVectorFromDictionary(face) else {
            throw DocumentError.load
        }
        
        DispatchQueue.main.async {
            self.propagate(vector)
        }
    }

}

