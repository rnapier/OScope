//
//  HighlightButton.swift
//  OScope
//
//  Created by Rob Napier on 7/16/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import QuartzCore

class HighlightButton: UIButton {

  let borderLayer = CAShapeLayer()
  let activeColor = UIColor.blueColor()

  var value : Bool = false {
  didSet { update() }
  }

  override var enabled : Bool  {
  didSet {update() }
  }

  func setup() {
    borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5.0).CGPath
    borderLayer.fillColor = nil
    borderLayer.strokeColor = activeColor.CGColor
    borderLayer.frame = layer.bounds
    layer.addSublayer(borderLayer)
    update()
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    setup()
  }

  init(frame: CGRect)  {
    super.init(frame: frame)
    setup()
  }

  func update() {
    if value {
      borderLayer.fillColor = activeColor.CGColor
      setTitleColor(UIColor.whiteColor(), forState: .Normal)
      setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }
    else {
      borderLayer.fillColor = nil
      setTitleColor(activeColor, forState: .Normal)
      setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }
  }
}
