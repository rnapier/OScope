//
//  KnobRenderer.swift
//  OScope
//
//  Created by Rob Napier on 7/17/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

// Based on RWKnobControl (https://github.com/sammyd/RW-KnobControl)

import QuartzCore

class KnobRenderer {
  let trackLayer = CAShapeLayer()
  let pointerLayer = CAShapeLayer()

  var pointerLength:CGFloat = 0.0 {
  didSet {
    updateTrackShape()
    updatePointerShape()
  }
  }

  var lineWidth:CGFloat = 0.0 {
  didSet {
    trackLayer.lineWidth = lineWidth
    pointerLayer.lineWidth = lineWidth
    updateTrackShape()
    updatePointerShape()
  }
  }

  var startAngle:CGFloat = 0.0 {
  didSet {
    updateTrackShape()
  }
  }

  var endAngle:CGFloat = 0.0 {
  didSet {
    updateTrackShape()
  }
  }

  var color:UIColor = UIColor.clearColor() {
  didSet {
    trackLayer.strokeColor = color.CGColor
    pointerLayer.strokeColor = color.CGColor
  }
  }

  var _primitivePointerAngle:CGFloat = 0.0
  var pointerAngle:CGFloat {
  get { return _primitivePointerAngle }
  set { setPointerAngle(newValue, animated: false) }
  }

  init() {
    trackLayer.fillColor = UIColor.clearColor().CGColor
    pointerLayer.fillColor = UIColor.clearColor().CGColor
  }

  func updateTrackShape() {
    let center = CGPointMake(
      CGRectGetWidth(trackLayer.bounds)/2.0,
      CGRectGetHeight(trackLayer.bounds)/2)

    let offset = max(pointerLength, lineWidth / 2.0)

    let radius = min(CGRectGetHeight(trackLayer.bounds),
      CGRectGetWidth(trackLayer.bounds)) / 2.0 - offset;

    let ring = UIBezierPath(arcCenter:center,
      radius:radius,
      startAngle:startAngle,
      endAngle:endAngle,
      clockwise:true)
    trackLayer.path = ring.CGPath
  }

  func updatePointerShape() {
    let pointer = UIBezierPath()
    pointer.moveToPoint(CGPointMake(CGRectGetWidth(pointerLayer.bounds) - pointerLength - lineWidth/2.0,
      CGRectGetHeight(pointerLayer.bounds) / 2.0))
    pointer.addLineToPoint(CGPointMake(CGRectGetWidth(pointerLayer.bounds),
      CGRectGetHeight(pointerLayer.bounds) / 2.0))
    pointerLayer.path = pointer.CGPath
  }

  func updateWithBounds(bounds: CGRect) {
    trackLayer.bounds = bounds
    trackLayer.position = CGPointMake(CGRectGetWidth(bounds)/2.0, CGRectGetHeight(bounds)/2.0)
    updateTrackShape()

    pointerLayer.bounds = trackLayer.bounds
    pointerLayer.position = trackLayer.position
    updatePointerShape()
  }

  func setPointerAngle(newValue:CGFloat, animated:Bool) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

    pointerLayer.transform = CATransform3DMakeRotation(newValue, 0, 0, 1)

    if(animated) {
      // Provide an animation
      // Key-frame animation to ensure rotates in correct direction
      let midAngle = (max(pointerAngle, _primitivePointerAngle) -
        min(pointerAngle, _primitivePointerAngle) ) / 2.0 +
        min(pointerAngle, _primitivePointerAngle)
      let animation = CAKeyframeAnimation(keyPath:"transform.rotation.z")

      animation.duration = 0.4
      animation.values = [_primitivePointerAngle, midAngle, newValue]
      animation.keyTimes = [0, 0.3, 1.0]
      animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
      pointerLayer.addAnimation(animation, forKey: "rotate")
    }

    _primitivePointerAngle = newValue

    CATransaction.commit()
  }

}