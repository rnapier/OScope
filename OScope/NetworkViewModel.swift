//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/14/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import CoreGraphics

struct SignalSourceLocation {
  let signalSource: SignalSource
  let offset: Int
  let height: Int
  let inputs: [SignalSourceLocation]
}

struct NetworkViewModel {
  let output : SignalSource
  let bounds : CGRect
}

func signalSourceLocation(root: SignalSource, offset:Int) -> SignalSourceLocation {
  var children = [SignalSourceLocation]()
  var height = 0
  for (index, input) in enumerate(root.inputs) {
    let child = signalSourceLocation(input, offset + index)
    height += child.height
    children.append(child)
  }

  return SignalSourceLocation(signalSource: root, offset: offset, height: max(height, 1), inputs: children)
}

