//
//  CanvasViewController.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa
import keyframes
import KVOController

class CanvasViewController: NSViewController, UsesVector {

    private var vectorLayer: KFVectorLayer!
    fileprivate var playbackController: PlaybackViewController!
    
    var vector: KFVector? {
        didSet {
            updateUI()
        }
    }
    
    var canvas: CanvasView? {
        return view as? CanvasView
    }
    
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canvas?.target = self
        canvas?.action = #selector(togglePlayback(_:))
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        playbackController = PlaybackViewController()
        addChildViewController(playbackController)
        
        view.addSubview(playbackController.view)
        playbackController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playbackController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playbackController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        updateUI()
        
        kvoController.observe(playbackController, keyPath: #keyPath(PlaybackViewController.progress), options: [.initial, .new], action: #selector(seek))
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
    }
    
    @IBAction func seek(_ sender: Any? = nil) {
        guard vectorLayer != nil && playbackController != nil else { return }
        
        vectorLayer.seek(toProgress: CGFloat(playbackController.progress))
    }
    
    @IBAction func play(_ sender: Any? = nil) {
        guard vectorLayer != nil else { return }
        
        vectorLayer.resumeAnimation()
        isPlaying = true
    }
    
    @IBAction func pause(_ sender: Any? = nil) {
        guard vectorLayer != nil else { return }
        
        vectorLayer.pauseAnimation()
        isPlaying = false
    }
    
    @IBAction func togglePlayback(_ sender: Any? = nil) {
        guard vectorLayer != nil else { return }
        
        if isPlaying {
            pause()
        } else {
            play()
        }
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

