//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/14/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

struct NetworkLayoutNode {
  let root: SignalSource
  let offset: Int
  let height: Int
  let layer: Int
  let children: [NetworkLayoutNode]

  var depth: Int { get {
    return 1 + children.map{$0.depth}.reduce(0, combine: max)
  }
  }

  var tree : [NetworkLayoutNode] { get {
    var result = [self]
    for node in children {
      result.extend(node.tree)
    }
    return result
  }
  }

  init(root: SignalSource, layer: Int = 0, offset: Int = 0) {
    self.root = root
    self.offset = offset
    self.layer = layer

    var children = [NetworkLayoutNode]()
    var height = 0
    for (index, input) in enumerate(root.inputs) {
      let child = NetworkLayoutNode(root: input, layer: layer + 1, offset: offset + index)
      height += child.height
      children.append(child)
    }

    self.children = children
    self.height = max(height, 1)
  }
}
