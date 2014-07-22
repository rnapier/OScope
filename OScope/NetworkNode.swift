//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/14/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

struct NetworkNode {
  let source: SignalSource
  let layer: Int
  let offset: Int

  let children: [NetworkNode]
  let height: Int

  var depth: Int { return 1 + children.map{$0.depth}.reduce(0, combine: max) }

  init(source: SignalSource, layer: Int = 0, offset: Int = 0) {
    self.source = source
    self.layer = layer
    self.offset = offset

    self.children = [NetworkNode]()
    self.height = 0
    for input in source.inputs {
      let child = NetworkNode(source: input, layer: layer + 1, offset: offset + self.height)
      self.children.append(child)
      self.height += child.height
    }
    self.height = max(self.height, 1)
  }
}
