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

  let signalLayer = SignalLayer()
  let axesLayer = CAShapeLayer()
  let gridLayer = CAShapeLayer()

  let verticalDivisions = 8
  let horizontalDivisions = 12

  func setup() {
    self.clipsToBounds = true

    self.signalLayer.frame = self.bounds
    self.signalLayer.strokeColor = UIColor.whiteColor().CGColor
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

  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setup()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  override var bounds : CGRect {
    didSet {
      self.signalLayer.frame = self.bounds
      self.axesLayer.frame = self.bounds
      self.axesLayer.path = self.axesPath().CGPath
      self.gridLayer.frame = self.bounds
      self.gridLayer.path = self.gridPath().CGPath
      self.updateVisualizer()
    }
  }

  var source : SignalSource? {
    didSet {
      self.updateVisualizer()
    }
  }

  var yScale : VisualizerScale = .Automatic {
    didSet {
      self.visualizer = self.visualizer?.withYScale(self.yScale)
    }
  }

  var secondsPerDiv : SignalTime = 1 * Millisecond {
    didSet {
      self.updateVisualizer()
    }
  }

  private(set) var visualizer : Visualizer? {
    get { return self.signalLayer.visualizer }
    set { self.signalLayer.visualizer = newValue }
  }

  var domain : VisualizerDomain = .Time {
    didSet {
      self.updateVisualizer()
    }
  }

  func updateVisualizer() {
    self.visualizer = self.source.map { source in
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
      return Visualizer(waveform:waveform, frame: self.bounds, yScale: self.yScale)
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
  var visualizer: Visualizer? {
    didSet {
      self.setNeedsDisplay()
    }
  }

  func setup() {
    self.lineJoin = kCALineCapRound
    self.lineCap = kCALineCapRound
    self.lineWidth = 1.5
  }

  override init() {
    super.init()
    self.setup()
  }

  required init(coder: NSCoder!) {
    super.init(coder: coder)
    self.setup()
  }

  override func display() {
    let newPath = self.visualizer?.path.CGPath
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.3
    animation.fromValue = self.path
    animation.toValue = newPath
    self.addAnimation(animation, forKey: "path")
    self.path = newPath
  }
}