//
//  CanvasViewController.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa
import keyframes

class CanvasViewController: NSViewController, UsesVector {

    private var vectorLayer: KFVectorLayer!
    
    var vector: KFVector? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        updateUI()
    }
    
    private func updateUI() {
        guard let vector = vector, isViewLoaded else { return }
        
        if vectorLayer == nil {
            vectorLayer = KFVectorLayer()
        } else {
            vectorLayer.removeFromSuperlayer()
        }
        
        resizeLayer()
        vectorLayer.faceModel = vector
        
        view.layer?.addSublayer(vectorLayer)
        
        vectorLayer.startAnimation()
    }
    
    private func resizeLayer() {
        guard vectorLayer != nil && isViewLoaded else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(0)
        
        let longSide = max(view.bounds.width, view.bounds.height)
        let shortSide = min(view.bounds.width, view.bounds.height)
        
        vectorLayer.frame = CGRect(x: longSide / 4, y: shortSide / 2 - longSide / 4, width: longSide / 2, height: longSide / 2)
        
        CATransaction.commit()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        resizeLayer()
    }

}

