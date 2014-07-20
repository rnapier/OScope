//
//  SignalGraphViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import QuartzCore

class SignalVisualizerView: UIView {

  let signalLayer = CAShapeLayer()
  let gridLayer = CAShapeLayer()

  func setup() {
    clipsToBounds = true

    signalLayer.frame = bounds
    signalLayer.strokeColor = UIColor.whiteColor().CGColor
    signalLayer.path = flatLine().CGPath
    layer.addSublayer(signalLayer)

    gridLayer.frame = bounds
    gridLayer.path = axesPath().CGPath
    gridLayer.strokeColor = UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5).CGColor
    layer.addSublayer(gridLayer)
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    setup()
  }

  init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  var source : SignalSource? {
  didSet {
    visualizer = source.map{SignalVisualizer(source: $0, domain: self.domain, frame:self.bounds, xScale:1, yScale:self.yScale)}
  }
  }

  var yScale : VisualizerScale = .Automatic {
  didSet {
    visualizer = visualizer?.withYScale(yScale)
  }
  }

  var visualizer : SignalVisualizer? {
  didSet {
    let newPath = visualizer?.path().result().CGPath
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.3
    animation.fromValue = signalLayer.path
    animation.toValue = newPath
    signalLayer.addAnimation(animation, forKey: "path")
    signalLayer.path = newPath
  }
  }

  var domain : VisualizerDomain = .Time {
  didSet {
    visualizer = source.map{SignalVisualizer(source: $0, domain: self.domain, frame:self.bounds, xScale:1, yScale:self.yScale)}
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
