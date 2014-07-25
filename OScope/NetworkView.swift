//
//  NetworkView.swift
//  OScope
//
//  Created by Rob Napier on 7/16/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import QuartzCore

class NetworkView: UIView {
  var viewModel : NetworkViewModel? {
  didSet {
    self.setNeedsLayout()
    self.setNeedsDisplay()
  }
  }

  var connectionLayers = [CAShapeLayer]()
  var nodeViews = [UIView]()

  override func layoutSubviews() {
    for v in self.nodeViews {
      v.removeFromSuperview()
    }
    self.nodeViews.removeAll(keepCapacity: true)

    for l in self.connectionLayers {
      l.removeFromSuperlayer()
    }
    self.connectionLayers.removeAll(keepCapacity: true)

    if let viewModel = self.viewModel {
      for layout in flatten(viewModel.layout(frame: self.bounds), {$0.inputs}) {
        addNodeView(layout)
        addConnections(layout)
      }
    }
  }

  func addNodeView(layout: NetworkNodeLayout) {
    let nodeView = UIView(frame: layout.frame)
    nodeView.tag = 1
    let nodeLayer = CAShapeLayer()
    nodeLayer.frame = nodeView.bounds
    nodeLayer.path = layout.nodePath.CGPath
    nodeLayer.fillColor = UIColor.clearColor().CGColor
    nodeLayer.strokeColor = UIColor.blackColor().CGColor

    nodeView.layer.addSublayer(nodeLayer)
    self.addSubview(nodeView)
    self.nodeViews += nodeView
  }

  func addConnections(layout: NetworkNodeLayout) {
    let connectionLayer = CAShapeLayer()
    connectionLayer.frame = self.bounds
    connectionLayer.path = layout.connectionPaths.CGPath
    connectionLayer.fillColor = UIColor.clearColor().CGColor
    connectionLayer.strokeColor = UIColor.blackColor().CGColor
    self.layer.addSublayer(connectionLayer)
    self.connectionLayers += connectionLayer
  }
}

