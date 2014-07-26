//
//  NetworkViewModel.swift
//  OScope
//
//  Created by Rob Napier on 7/15/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import SignalKit

let insetScale = CGFloat(5.0)

func inputPoint(#frame: CGRect, #index: Int, #inputCount:Int) -> CGPoint {
  return CGPointMake(
    CGRectGetMinX(frame),
    CGRectGetMinY(frame) + CGRectGetHeight(frame) * (CGFloat(index + 1)/CGFloat(inputCount + 1)))
}

struct NetworkNodeLayout {
  let node: NetworkNode
  let frame: CGRect
  var bounds: CGRect { return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) }
  let inputPoints: [CGPoint]
  let outputPoint: CGPoint
  let inputs: [NetworkNodeLayout]

  var nodePath: UIBezierPath {
    let path = UIBezierPath(rect:self.frame)
    let v = SignalVisualizer(source: self.node.source, domain:.Time, frame:self.frame, sampleRate: 44100*Hertz, yScale:.Automatic)
    path.appendPath(v.path)
    return path
  }

  var connectionPaths : UIBezierPath {
  let connections = UIBezierPath()
    for (index, input) in enumerate(self.inputs) {
      connections.moveToPoint(self.inputPoints[index])
      connections.addLineToPoint(self.inputs[index].outputPoint)
    }
    return connections
  }

  init(node:NetworkNode, nodeSize:CGSize, totalDepth:Int) {
    self.node = node

    let frame = CGRectInset(
      CGRectMake(
        nodeSize.width * CGFloat(totalDepth - node.layer - 1),
        nodeSize.height * CGFloat(node.offset),
        nodeSize.width, nodeSize.height),
      nodeSize.width / insetScale, nodeSize.height / insetScale)
    self.frame = frame

    self.inputPoints = indices(node.children).map { index in inputPoint(frame:frame, index:index, inputCount:node.children.count) }
    self.outputPoint = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame))

    self.inputs = node.children.map{ return NetworkNodeLayout(node:$0, nodeSize:nodeSize, totalDepth: totalDepth) }
  }
}

struct NetworkViewModel {
  let rootNode : NetworkNode

  init(rootSource: SignalSource) {
    self.rootNode = NetworkNode(source: rootSource)
  }

  func layout(#frame: CGRect) -> NetworkNodeLayout {
    let size = CGSizeMake(CGRectGetWidth(frame)/CGFloat(self.rootNode.depth), CGRectGetHeight(frame)/CGFloat(self.rootNode.height))
    return NetworkNodeLayout(node: rootNode, nodeSize:size, totalDepth:rootNode.depth)
  }
}
