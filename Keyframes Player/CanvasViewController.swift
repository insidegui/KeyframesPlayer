//
//  CanvasViewController.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 12/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa
import Keyframes
import KVOController

class CanvasViewController: NSViewController, UsesVector {

    private var vectorLayer: KFVectorLayer!
    fileprivate var playbackController: PlaybackViewController!
    
    @objc var vector: KFVector? {
        didSet {
            updateUI()
        }
    }
    
    @objc var canvas: CanvasView? {
        return view as? CanvasView
    }
    
    @objc var isPlaying = false
    
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
        
        if vectorLayer != nil {
            vectorLayer.removeFromSuperlayer()
        }
        
        vectorLayer = KFVectorLayer()
        
        resizeLayer()
        vectorLayer.setFaceModel(vector)
        vectorLayer.startAnimation()
        
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
        guard let vector = vector, vectorLayer != nil && isViewLoaded else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationDuration(0)

        let size = calculateAspectFillSize(originalSize: vector.canvasSize, cropSize: view.bounds.size)
        vectorLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        vectorLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)

        CATransaction.commit()
    }

    private func calculateAspectFillSize(originalSize: CGSize, cropSize: CGSize) -> CGSize {
        let cropRatio = cropSize.width / cropSize.height;
        let originalRatio = originalSize.width / originalSize.height;

        if (cropRatio > originalRatio) {
            return CGSize(width: originalSize.width * cropSize.height / originalSize.height, height: cropSize.height)
        } else {
            return CGSize(width: cropSize.width, height: originalSize.height * cropSize.width / originalSize.width)
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        resizeLayer()
    }

}

