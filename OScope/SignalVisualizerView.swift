//
//  SignalGraphViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import QuartzCore
import SignalKit

class SignalVisualizerView: UIView {

    private let signalLayer = SignalLayer()
    private let axesLayer = CAShapeLayer()
    private let gridLayer = CAShapeLayer()

    let verticalDivisions = 8
    let horizontalDivisions = 12

    private func setup() {
        self.clipsToBounds = true

        layer.addSublayer(self.signalLayer)

        self.axesLayer.frame = self.bounds
        self.axesLayer.path = self.axesPath().CGPath
        self.axesLayer.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.66).CGColor
        self.axesLayer.lineWidth = 3
        self.layer.addSublayer(self.axesLayer)

        self.gridLayer.frame = self.bounds
        self.gridLayer.path = self.gridPath().CGPath
        self.gridLayer.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.33).CGColor
        self.gridLayer.contentsGravity = kCAGravityCenter
        self.layer.addSublayer(self.gridLayer)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    override var bounds : CGRect {
        didSet {
            self.axesLayer.frame = self.bounds
            self.axesLayer.path = self.axesPath().CGPath
            self.gridLayer.frame = self.bounds
            self.gridLayer.path = self.gridPath().CGPath
            self.updateVisualizer()
        }
    }

    var visualizer : Visualizer? {
        didSet { self.setNeedsDisplay() }
    }

    var source : SignalSource? {
        didSet {
            self.updateVisualizer()
        }
    }

    var voltsPerDiv : VisualizerScale = .Automatic {
        didSet {
            self.updateVisualizer()
        }
    }

    var secondsPerDiv : SignalTime = 1 * Millisecond {
        didSet {
            self.updateVisualizer()
        }
    }

    var domain : VisualizerDomain = .Time {
        didSet {
            self.updateVisualizer()
        }
    }

    func updateVisualizer() {
        if let source = self.source {
            let times = SignalSampleTimes(
                start: 0*Second,
                end: self.secondsPerDiv * self.horizontalDivisions,
                samples: Int(ceil(CGRectGetWidth(self.bounds) + 1)))
            let waveform: Waveform = {
                switch self.domain {
                case .Time:
                    return SignalWaveform(source: source, sampleTimes: times)
                case .Frequency:
                    return SpectrumWaveform(source: source, sampleTimes: times)
                }

                }()
            self.visualizer = Visualizer(waveform: waveform, frame: self.bounds, yScale: self.voltsPerDiv)
            self.signalLayer.path = self.visualizer?.path.CGPath
        }
    }

    func gridPath() -> UIBezierPath {
        let path = UIBezierPath()

        let vertSpacing = CGRectGetHeight(self.bounds) / CGFloat(self.verticalDivisions)
        let minX = CGRectGetMinX(self.bounds)
        let maxX = CGRectGetMaxX(self.bounds)
        for i in 1 ..< self.verticalDivisions {
            let y = vertSpacing * CGFloat(i)
            path.moveToPoint(CGPointMake(minX, y))
            path.addLineToPoint(CGPointMake(maxX, y))
        }

        let horizSpecing = CGRectGetWidth(self.bounds) / CGFloat(self.horizontalDivisions)
        let minY = CGRectGetMinY(self.bounds)
        let maxY = CGRectGetMaxY(self.bounds)
        for i in 1 ..< self.horizontalDivisions {
            let x = horizSpecing * CGFloat(i)
            path.moveToPoint(CGPointMake(x, minY))
            path.addLineToPoint(CGPointMake(x, maxY))
        }
        return path
    }

    func axesPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)))
        path.addLineToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds)))

        path.moveToPoint(CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds)))
        path.addLineToPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds)))

        path.lineWidth = 10
        
        return path
    }
}

class SignalLayer : CAShapeLayer {
    var waveform: Waveform? {
        didSet {
            self.updatePath()
        }
    }
    
    var yScale: CGFloat = 1.0
    
    func updatePath() {
        let path = self.waveform?.path.copy() as UIBezierPath
        path.applyTransform(CGAffineTransformMakeScale(1, -self.yScale))
        self.path = path.CGPath
    }
    
    func setup() {
        self.lineJoin = kCALineCapRound
        self.lineCap = kCALineCapRound
        self.lineWidth = 1.5
        self.strokeColor = UIColor.whiteColor().CGColor
    }
    
    override init() {
        super.init()
        self.setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override init(layer: AnyObject!) {
        super.init(layer: layer)
    }
}