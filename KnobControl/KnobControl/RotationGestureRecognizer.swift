//
//  RotationGestureRecognizer.swift
//  OScope
//
//  Created by Rob Napier on 7/25/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class RotationGestureRecognizer : UIPanGestureRecognizer {

  var touchAngle: CGFloat

  init(target: AnyObject?, action: Selector) {
    self.touchAngle = 0
    super.init(target: target, action: action)
    self.maximumNumberOfTouches = 1;
    self.minimumNumberOfTouches = 1;
  }

  override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
    super.touchesBegan(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }

  override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
    super.touchesMoved(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }

  func updateTouchAngleWithTouches(touches: NSSet) {
    if let touch = touches.anyObject() as? UITouch {
      let touchPoint = touch.locationInView(self.view)
      self.touchAngle = self.calculateAngleToPoint(touchPoint)
    }
  }

  func calculateAngleToPoint(point: CGPoint) -> CGFloat {
    // Offset by the center
    let centerOffset = CGPointMake(point.x - CGRectGetMidX(self.view.bounds),
      point.y - CGRectGetMidY(self.view.bounds))
    return atan2(centerOffset.y, centerOffset.x)
  }
}
