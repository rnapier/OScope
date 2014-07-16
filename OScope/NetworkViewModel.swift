//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/15/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import CoreGraphics

struct NetworkViewModel {
  let root : NetworkLayoutNode
  
  init(root: SignalSource) {
    self.root = NetworkLayoutNode(root: root, layer: 0, offset:0) // FIXME: Simpler (root) constructor crashes in Beta3
  }

  func layout(bounds: CGRect) -> [(NetworkLayoutNode, CGRect)] {
    let size = CGSizeMake(CGRectGetWidth(bounds)/CGFloat(root.depth), CGRectGetHeight(bounds)/CGFloat(root.height))

    var result: [(NetworkLayoutNode, CGRect)] = []

    for node in root.tree {
      result.append((root,
        CGRectMake(size.width * CGFloat(node.layer),
          size.height * CGFloat(node.offset),
          size.width, size.height)))
    }

    return result
  }
}
