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

  let signalLayer = CAShapeLayer()
  let gridLayer = CAShapeLayer()

  func setup() {
    clipsToBounds = true

    self.signalLayer.frame = self.bounds
    self.signalLayer.strokeColor = UIColor.whiteColor().CGColor
    self.signalLayer.path = self.flatLine().CGPath
    layer.addSublayer(self.signalLayer)

    self.gridLayer.frame = self.bounds
    self.gridLayer.path = self.axesPath().CGPath
    self.gridLayer.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5).CGColor
    self.layer.addSublayer(self.gridLayer)
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setup()
  }

  init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  var source : SignalSource? {
  didSet {
    self.visualizer = self.source.map{SignalVisualizer(source: $0, domain: self.domain, frame:self.bounds, sampleRate:44100.hertz, yScale:self.yScale)}
  }
  }

  var yScale : VisualizerScale = .Automatic {
  didSet {
    self.visualizer = self.visualizer?.withYScale(self.yScale)
  }
  }

  var visualizer : SignalVisualizer? {
  didSet {
    let newPath = self.visualizer?.path.CGPath
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.3
    animation.fromValue = signalLayer.path
    animation.toValue = newPath
    self.signalLayer.addAnimation(animation, forKey: "path")
    self.signalLayer.path = newPath
  }
  }

  var domain : VisualizerDomain = .Time {
  didSet {
    self.visualizer = self.source.map{SignalVisualizer(source: $0, domain: self.domain, frame:self.bounds, sampleRate:44100.hertz, yScale:self.yScale)}
  }
  }

  func axesPath() -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)))
    path.addLineToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds)))

    path.moveToPoint(CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds)))
    path.addLineToPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds)))

    path.lineWidth = 3

    return path
  }

  func flatLine() -> UIBezierPath {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds)))
    path.addLineToPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds)))
    return path
  }
}
