//
//  SignalGraphViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class SignalVisualizerView: UIView {

  var source : SignalSource? {
  didSet {
    visualizer = source.map{SignalVisualizer(source: $0)}
    setNeedsDisplay()
  }
  }

  var yScale : VisualizerScale = .Automatic {
  didSet {
    setNeedsDisplay()
  }
  }

  var visualizer : SignalVisualizer?

  override func drawRect(rect: CGRect) {
    drawGrid()
    if let source = source {
      UIColor(white: 1, alpha: 1).set()
      visualizer?.path(bounds, xScale:1, yScale:yScale).stroke()
    }
  }

  func drawGrid() {
    drawOrigin()
  }

  func drawOrigin() {
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)))
    path.addLineToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds)))

    path.moveToPoint(CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds)))
    path.addLineToPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds)))

    path.lineWidth = 3

    UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 0.5).set()

    path.stroke()
  }
}
