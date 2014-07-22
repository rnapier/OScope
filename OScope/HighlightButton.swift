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
  didSet { self.update() }
  }

  override var enabled : Bool  {
  didSet { self.update() }
  }

  func setup() {
    self.borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5.0).CGPath
    self.borderLayer.fillColor = nil
    self.borderLayer.strokeColor = self.activeColor.CGColor
    self.borderLayer.frame = self.layer.bounds
    self.layer.addSublayer(self.borderLayer)
    self.update()
  }

  init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setup()
  }

  init(frame: CGRect)  {
    super.init(frame: frame)
    self.setup()
  }

  func update() {
    if value {
      self.borderLayer.fillColor = activeColor.CGColor
      self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      self.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }
    else {
      self.borderLayer.fillColor = nil
      self.setTitleColor(activeColor, forState: .Normal)
      self.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
    }
  }
}
