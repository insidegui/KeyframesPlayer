//
//  Document.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa
import Keyframes

class Document: NSDocument {
    
    enum DocumentError: Error {
        case load
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }
    
    private func propagate(_ vector: KFVector) {
        windowControllers.forEach {
            if var vc = $0.contentViewController as? UsesVector {
                vc.vector = vector
            }
        }
    }
    
    override func read(from url: URL, ofType typeName: String) throws {
        try load(from: url)
    }
    
    private var lastModificationDate = Date.distantPast
    
    private var vector: KFVector?
    
    private func load(from url: URL) throws {
        let data = try Data(contentsOf: url)
        
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let face = obj as? [AnyHashable: Any] else {
            throw DocumentError.load
        }
        
        guard let vector = KFVectorFromDictionary(face) else {
            throw DocumentError.load
        }
        
        self.vector = vector
        
        DispatchQueue.main.async {
            self.propagate(vector)
        }
        
        self.lastModificationDate = fetchLastModificationDate()
    }
    
    private func fetchLastModificationDate() -> Date {
        guard let url = presentedItemURL else {
            return Date.distantPast
        }
        
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) else {
            return Date.distantPast
        }
        
        return attributes[.modificationDate] as? Date ?? Date.distantPast
    }
    
    override func presentedItemDidChange() {
        super.presentedItemDidChange()
        
        guard let url = presentedItemURL else { return }
        
        let date = fetchLastModificationDate()
        
        guard lastModificationDate != date else { return }
        
        do {
            try load(from: url)
        } catch {
            NSLog("Error reading updated document from path: \(url.path)")
        }
    }
    
    @IBAction func exportCoreAnimationArchive(_ sender: Any?) {
        guard let vector = self.vector else { return }
        
        let vectorLayer = KFVectorLayer()
        vectorLayer.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        vectorLayer.setFaceModel(vector)
        vectorLayer.startAnimation()
        
        let panel = NSSavePanel()
        panel.allowedFileTypes = ["caar", "ca"]
        panel.runModal()
        
        guard let url = panel.url else { return }
        
        let exporter = CAExporter(rootLayer: vectorLayer)
        
        do {
            try exporter.exportToFile(at: url)
        } catch {
            NSApp.presentError(error)
        }
    }

}

