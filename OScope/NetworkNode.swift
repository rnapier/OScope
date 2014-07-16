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

    children = [NetworkNode](
      map(enumerate(source.inputs),
        { index, input in
          NetworkNode(source: input, layer: layer + 1, offset: offset + index)
      }))

    height = max(children.reduce(0, combine: { sum, child in sum + child.height }), 1)
  }
}
