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
    if let viewModel = self.viewModel {
      for layout in flatten(viewModel.layout(frame: self.bounds), {$0.inputs}) {
        layout.nodePath.stroke()
        layout.connectionPaths.stroke()
      }
    }
  }
}

