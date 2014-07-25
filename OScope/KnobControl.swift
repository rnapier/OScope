//
//  KnobControl.swift
//  OScope
//
//  Created by Rob Napier on 7/17/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

// Based on RWKnobControl (https://github.com/sammyd/RW-KnobControl)

import UIKit

class KnobControl : UIControl {
  var minimumValue:CGFloat = 0.0
  var maximumValue:CGFloat = 1.0

  var _primitiveValue:CGFloat = 0.0
  var value:CGFloat {
  get { return self._primitiveValue }
  set { self.setValue(newValue, animated: false) }
  }

  var startAngle:CGFloat {
  get { return self.knobRenderer.startAngle }
  set { self.knobRenderer.startAngle = newValue }
  }

  var endAngle:CGFloat {
  get { return self.knobRenderer.endAngle }
  set { self.knobRenderer.endAngle = newValue }
  }

  let continuous = true

  lazy var gestureRecognizer : RotationGestureRecognizer = {
    return RotationGestureRecognizer(target: self, action: "handleGesture:")
    }()

  let knobRenderer = KnobRenderer()

  var lineWidth : CGFloat {
  get { return self.knobRenderer.lineWidth }
  set { self.knobRenderer.lineWidth = newValue }
  }

  var pointerLength : CGFloat {
  get { return self.knobRenderer.pointerLength }
  set { self.knobRenderer.pointerLength = newValue }
  }

  func setup() {
    addGestureRecognizer(self.gestureRecognizer)
    self.createKnobUI()
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setup()
  }

  init(frame: CGRect)  {
    super.init(frame: frame)
    self.setup()
  }

  func createKnobUI() {
    self.knobRenderer.updateWithBounds(bounds)
    self.knobRenderer.color = tintColor
    self.knobRenderer.startAngle = CGFloat(-M_PI * 11.0 / 8.0)
    self.knobRenderer.endAngle = CGFloat(M_PI * 3.0 / 8.0)
    self.knobRenderer.pointerAngle = knobRenderer.startAngle
    self.knobRenderer.lineWidth = 2.0
    self.knobRenderer.pointerLength = 6.0
    layer.addSublayer(self.knobRenderer.trackLayer)
    layer.addSublayer(self.knobRenderer.pointerLayer)
  }

  func setValue(newValue: CGFloat, animated:Bool) {
    if newValue != self._primitiveValue {
      self.willChangeValueForKey("value")

      // Save the value to the backing ivar
      // Make sure we limit it to the requested bounds
      self._primitiveValue = min(self.maximumValue, max(self.minimumValue, newValue))

      // Now let's update the knob with the correct angle
      let angleRange = self.endAngle - self.startAngle
      let valueRange = self.maximumValue - self.minimumValue
      let angleForValue = (self._primitiveValue - self.minimumValue) / valueRange * angleRange + self.startAngle
      self.knobRenderer.setPointerAngle(angleForValue, animated:animated)
      self.didChangeValueForKey("value")
    }
  }

  func handleGesture(gesture:RotationGestureRecognizer) {
    // Mid-point angle
    let midPointAngle = (2.0 * CGFloat(M_PI) + self.startAngle - self.endAngle) / 2.0 + self.endAngle

    // Ensure the angle is within a suitable range
    var boundedAngle = gesture.touchAngle
    if boundedAngle > midPointAngle {
      boundedAngle -= CGFloat(2.0 * M_PI)
    } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(M_PI)) {
      boundedAngle += CGFloat(2.0 * M_PI)
    }
    // Bound the angle to within the suitable range
    boundedAngle = min(self.endAngle, max(self.startAngle, boundedAngle));

    // Convert the angle to a value
    let angleRange = self.endAngle - self.startAngle
    let valueRange = self.maximumValue - self.minimumValue
    let valueForAngle = (boundedAngle - self.startAngle) / angleRange * valueRange + self.minimumValue

    // Set the control to this value
    self.value = valueForAngle

    // Notify of value change
    if self.continuous {
      self.sendActionsForControlEvents(.ValueChanged)
    } else {
      // Only send an update if the gesture has completed
      switch gesture.state {
      case .Ended, .Cancelled:
        self.sendActionsForControlEvents(.ValueChanged)
      default:
        break
      }
    }
  }

  override func tintColorDidChange() {
    self.knobRenderer.color = tintColor
  }
}
