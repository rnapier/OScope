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

  override init(target: AnyObject, action: Selector) {
    self.touchAngle = 0
    super.init(target: target, action: action)
    self.maximumNumberOfTouches = 1;
    self.minimumNumberOfTouches = 1;
  }

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    //FIXME: where is touchesBegan(withEvent:)?
    super.touchesBegan(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }

  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    if let bounds = self.view?.bounds {
      let centerOffset = CGPointMake(point.x - CGRectGetMidX(bounds),
        point.y - CGRectGetMidY(bounds))
      return atan2(centerOffset.y, centerOffset.x)
    }
    preconditionFailure("Missing view")
  }
}

