//
//  SignalGraphViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class SignalVisualizerView: UIView {

  var signalSource : SignalSource? {
  didSet {
    setNeedsDisplay()
  }
  }

  override func drawRect(rect: CGRect) {
    if let signalSource = signalSource {
      SignalVisualizer(source: signalSource).path(rect).stroke()
    }
  }
}
