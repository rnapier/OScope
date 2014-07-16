//
//  SignalOutputGrapher.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

struct SignalVisualizer {
  let source : SignalSource

  func path(bounds:CGRect) -> UIBezierPath {
    let width  = CGRectGetWidth(bounds)
    let height = CGRectGetHeight(bounds)

    let yZero  = CGRectGetMidY(bounds)
    let xScale = CGFloat(1)
    let yScale = -height/2

    let transform = CGAffineTransformScale(
      CGAffineTransformMakeTranslation(0, yZero),
      xScale, yScale)

    let timeRange = Range(
      start:SignalTime(CGRectGetMinX(bounds)),
      end:SignalTime(CGRectGetMaxX(bounds)))

    let vals = timeRange.map { self.source.value($0) }

    let path = pathWithValues(vals)
    path.applyTransform(transform)
    return path
  }
}

func pathWithValues(values:[SignalValue]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    cycle.addLineToPoint(CGPointMake(CGFloat(t), CGFloat(values[t])))
  }
  cycle.addLineToPoint(CGPointMake(CGFloat(valCount), CGFloat(values[0])))
  return cycle
}
