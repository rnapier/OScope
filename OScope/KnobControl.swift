//
//  KnobControl.swift
//  OScope
//
//  Created by Rob Napier on 7/16/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

import QuartzCore

class KnobControl: UIControl {

  let enabledColor = UIColor.blueColor()
  let disabledColor = UIColor.grayColor().colorWithAlphaComponent(0.3)

  let knobLayer = CAShapeLayer()
  let pointerLayer = CAShapeLayer()

  var value : Float = 0 {
  didSet {
    updatePointer()
  }
  }

  override var enabled : Bool {
  didSet {
    knobLayer.strokeColor = enabled ? enabledColor.CGColor : disabledColor.CGColor
    pointerLayer.strokeColor = enabled ? UIColor.blackColor().CGColor : disabledColor.CGColor
  }
  }
  var minimumValue : Float = 0

  var maximumValue : Float = 1

  let minimumAngle = Float(3*M_PI_4)
  let maximumAngle = Float(2*M_PI + M_PI_4)

  func setup() {
    let center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
    let radius = CGRectGetWidth(bounds)/2

    knobLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(minimumAngle), endAngle: CGFloat(maximumAngle), clockwise: true).CGPath
    knobLayer.fillColor = nil
    knobLayer.strokeColor = enabledColor.CGColor
    knobLayer.frame = layer.bounds
    layer.addSublayer(knobLayer)

    let pointerPath = UIBezierPath()
    pointerPath.moveToPoint(center)
    pointerPath.addLineToPoint(CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)))

    pointerLayer.path = pointerPath.CGPath
    pointerLayer.strokeColor = UIColor.blackColor().CGColor
    pointerLayer.frame = layer.bounds
    pointerLayer.lineWidth = 2
    layer.addSublayer(pointerLayer)
    updatePointer()
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setup()
  }

  init(frame: CGRect) {
    super.init(frame:frame)
    self.setup()
  }

  func updatePointer() {
    let ratio = (value - minimumValue)/(maximumValue - minimumValue) - 0.5
    let angle = (maximumAngle - minimumAngle) * ratio
    let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    pointerLayer.transform = transform
  }
}