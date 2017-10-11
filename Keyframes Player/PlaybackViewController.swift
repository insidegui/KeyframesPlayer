//
//  PlaybackViewController.swift
//  Keyframes Player
//
//  Created by Guilherme Rambo on 13/12/16.
//  Copyright © 2016 Guilherme Rambo. All rights reserved.
//

import Cocoa

class PlaybackViewController: NSViewController {

    @objc var progress = 0.0 {
        willSet {
            willChangeValue(forKey: "progress")
        }
        didSet {
            didChangeValue(forKey: "progress")
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var backdropView: NSVisualEffectView? {
        return self.view as? NSVisualEffectView
    }
    
    fileprivate lazy var slider: NSSlider = {
        let s = NSSlider(value: 0, minValue: 0, maxValue: 1, target: self, action: #selector(sliderDidChange(sender:)))
        
        s.isContinuous = true
        s.translatesAutoresizingMaskIntoConstraints = false
        s.sizeToFit()
        
        return s
    }()
    
    override func loadView() {
        let vfxView = NSVisualEffectView(frame: .zero)
        vfxView.material = .mediumLight
        vfxView.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
        vfxView.blendingMode = .withinWindow
        vfxView.wantsLayer = true
        
        let separatorView = NSView(frame: NSRect(x: 0, y: -1, width: 0, height: 1))
        separatorView.wantsLayer = true
        separatorView.layer = CALayer()
        separatorView.layer?.backgroundColor = NSColor.lightGray.cgColor
        separatorView.layer?.opacity = 0.3
        separatorView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.minYMargin]
        self.view = vfxView
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 28).isActive = true
        view.layer?.zPosition = 9999
        
        vfxView.addSubview(separatorView)
        
        view.addSubview(slider)
        slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0).isActive = true
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc private func sliderDidChange(sender: NSSlider) {
        progress = sender.doubleValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
