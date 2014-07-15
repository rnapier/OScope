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
    setNeedsDisplay()
  }
  }

  override func drawRect(rect: CGRect) {
    if let source = source {
      SignalVisualizer(source: source).path(rect).stroke()
    }
  }
}
