//
//  NetworkView.swift
//  OScope
//
//  Created by Rob Napier on 7/16/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

func flatten<T>(root: T, children:((T)->[T])) -> [T] {
  var result = [root]
  for node in children(root) {
    result.extend(flatten(node, children))
  }
  return result
}


class NetworkView: UIView {
  var viewModel : NetworkViewModel? {
  didSet { setNeedsDisplay() }
  }

  override func drawRect(rect: CGRect) {
    if let viewModel = viewModel {
      for layout in flatten(viewModel.layout(bounds), {$0.inputs}) {
        UIBezierPath(rect:layout.frame).stroke()
        for (index, input) in enumerate(layout.inputs) {
          let line = UIBezierPath()
          line.moveToPoint(layout.inputPoints[index])
          line.addLineToPoint(layout.inputs[index].outputPoint)
          line.stroke()
        }
      }
    }
  }
}

