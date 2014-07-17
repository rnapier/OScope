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
  get { return _primitiveValue }
  set { setValue(newValue, animated: false) }
  }

  var startAngle:CGFloat {
  get { return knobRenderer.startAngle }
  set { knobRenderer.startAngle = newValue }
  }

  var endAngle:CGFloat {
  get { return knobRenderer.endAngle }
  set { knobRenderer.endAngle = newValue }
  }

  let continuous = true

  @lazy var gestureRecognizer : RWRotationGestureRecognizer = {
    return RWRotationGestureRecognizer(target: self, action: "handleGesture:")
    }()

  let knobRenderer = RWKnobRenderer()

  var lineWidth : CGFloat {
  get { return knobRenderer.lineWidth }
  set { knobRenderer.lineWidth = newValue }
  }

  var pointerLength : CGFloat {
  get { return knobRenderer.pointerLength }
  set { knobRenderer.pointerLength = newValue }
  }

  func setup() {
    addGestureRecognizer(gestureRecognizer)
    createKnobUI()
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    setup()
  }

  init(frame: CGRect)  {
    super.init(frame: frame)
    setup()
  }

  func createKnobUI() {
    knobRenderer.updateWithBounds(bounds)
    knobRenderer.color = tintColor
    knobRenderer.startAngle = CGFloat(-M_PI * 11.0 / 8.0)
    knobRenderer.endAngle = CGFloat(M_PI * 3.0 / 8.0)
    knobRenderer.pointerAngle = knobRenderer.startAngle
    knobRenderer.lineWidth = 2.0
    knobRenderer.pointerLength = 6.0
    layer.addSublayer(knobRenderer.trackLayer)
    layer.addSublayer(knobRenderer.pointerLayer)
  }

  func setValue(newValue: CGFloat, animated:Bool) {
    if newValue != _primitiveValue {
      willChangeValueForKey("value")

      // Save the value to the backing ivar
      // Make sure we limit it to the requested bounds
      _primitiveValue = min(maximumValue, max(minimumValue, newValue))

      // Now let's update the knob with the correct angle
      let angleRange = endAngle - startAngle
      let valueRange = maximumValue - minimumValue
      let angleForValue = (_primitiveValue - minimumValue) / valueRange * angleRange + startAngle
      knobRenderer.setPointerAngle(angleForValue, animated:animated)
      didChangeValueForKey("value")
    }
  }

  func handleGesture(gesture:RWRotationGestureRecognizer) {
    // Mid-point angle
    let midPointAngle = (2.0 * CGFloat(M_PI) + startAngle - endAngle) / 2.0 + endAngle

    // Ensure the angle is within a suitable range
    var boundedAngle = gesture.touchAngle
    if boundedAngle > midPointAngle {
      boundedAngle -= CGFloat(2.0 * M_PI)
    } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(M_PI)) {
      boundedAngle += CGFloat(2.0 * M_PI)
    }
    // Bound the angle to within the suitable range
    boundedAngle = min(endAngle, max(startAngle, boundedAngle));

    // Convert the angle to a value
    let angleRange = endAngle - startAngle
    let valueRange = maximumValue - minimumValue
    let valueForAngle = (boundedAngle - startAngle) / angleRange * valueRange + minimumValue

    // Set the control to this value
    value = valueForAngle

    // Notify of value change
    if continuous {
      sendActionsForControlEvents(.ValueChanged)
    } else {
      // Only send an update if the gesture has completed
      switch gesture.state {
      case .Ended, .Cancelled:
        sendActionsForControlEvents(.ValueChanged)
      default:
        break
      }
    }
  }

  override func tintColorDidChange() {
    knobRenderer.color = tintColor
  }
}
