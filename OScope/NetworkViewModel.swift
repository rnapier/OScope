//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/15/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import CoreGraphics

let insetScale = CGFloat(5.0)

struct NetworkNodeLayout {
  let node: NetworkNode
  let frame: CGRect

  init(node:NetworkNode, size:CGSize) {
    self.node = node
    frame = CGRectInset(
      CGRectMake(
        size.width * CGFloat(node.layer),
        size.height * CGFloat(node.offset),
        size.width, size.height),
      size.width / insetScale, size.height / insetScale)
  }
}

struct NetworkViewModel {
  let rootNode : NetworkNode
  
  init(rootSource: SignalSource) {
    self.rootNode = NetworkNode(source: rootSource)
  }

  func layout(bounds: CGRect) -> [NetworkNodeLayout] {
    let size = CGSizeMake(CGRectGetWidth(bounds)/CGFloat(rootNode.depth), CGRectGetHeight(bounds)/CGFloat(rootNode.height))
    return rootNode.tree.map { NetworkNodeLayout(node: $0, size:size) }
  }
}
