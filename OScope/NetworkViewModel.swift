//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/15/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import CoreGraphics

let insetScale = CGFloat(5.0)

func inputPoint(#frame: CGRect, #index: Int, #inputCount:Int) -> CGPoint {
  return CGPointMake(
    CGRectGetMinX(frame),
    CGRectGetMinY(frame) + CGRectGetHeight(frame) * (Float(index + 1)/Float(inputCount + 1)))
}

struct NetworkNodeLayout {
  let node: NetworkNode
  let frame: CGRect
  let inputPoints: [CGPoint]
  let outputPoint: CGPoint
  let inputs: [NetworkNodeLayout]

  init(node:NetworkNode, size:CGSize, totalDepth:Int) {
    self.node = node
    let frame = CGRectInset(
      CGRectMake(
        size.width * CGFloat(totalDepth - node.layer - 1),
        size.height * CGFloat(node.offset),
        size.width, size.height),
      size.width / insetScale, size.height / insetScale)
    self.frame = frame

    inputPoints = indices(node.children).map { index in inputPoint(frame:frame, index:index, inputCount:node.children.count) }
    outputPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame))

    inputs = node.children.map{ return NetworkNodeLayout(node:$0, size:size, totalDepth: totalDepth) }
  }
}

struct NetworkViewModel {
  let rootNode : NetworkNode
  
  init(rootSource: SignalSource) {
    self.rootNode = NetworkNode(source: rootSource)
  }

  func layout(bounds: CGRect) -> NetworkNodeLayout {
    let size = CGSizeMake(CGRectGetWidth(bounds)/CGFloat(rootNode.depth), CGRectGetHeight(bounds)/CGFloat(rootNode.height))
    return NetworkNodeLayout(node: rootNode, size:size, totalDepth:rootNode.depth) // .tree.map { NetworkNodeLayout(node: $0, size:size) }
  }
}
