//
//  NetworkView.swift
//  OScope
//
//  Created by Rob Napier on 7/16/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class NetworkView: UIView {
  var viewModel : NetworkViewModel? {
  didSet { setNeedsDisplay() }
  }

  override func drawRect(rect: CGRect) {
    if let viewModel = viewModel {
      for layout in viewModel.layout(bounds) {
        UIBezierPath(rect:layout.frame).stroke()
      }
    }
  }
}
