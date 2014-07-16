//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/14/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

struct NetworkNode {
  let source: SignalSource
  let offset: Int
  let height: Int
  let layer: Int
  let children: [NetworkNode]

  var depth: Int { return 1 + children.map{$0.depth}.reduce(0, combine: max) }

  var tree : [NetworkNode] {
    var result = [self]
    for node in children {
      result.extend(node.tree)
    }
    return result
  }

  init(source: SignalSource, layer: Int = 0, offset: Int = 0) {
    self.source = source
    self.offset = offset
    self.layer = layer

    var children = [NetworkNode]()
    var height = 0
    for (index, input) in enumerate(source.inputs) {
      let child = NetworkNode(source: input, layer: layer + 1, offset: offset + index)
      height += child.height
      children.append(child)
    }

    self.children = children
    self.height = max(height, 1)
  }
}
