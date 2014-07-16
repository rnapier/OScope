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

  func path(frame:CGRect) -> UIBezierPath {
    println(frame)
    let width  = CGRectGetWidth(frame)
    let height = CGRectGetHeight(frame)

    let yZero  = CGRectGetMidY(frame)
    let xScale = CGFloat(1)
    let yScale = -height/2

    let transform = CGAffineTransformScale(
      CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
      xScale, yScale)

    // TODO: In Beta3, you can't range over floats
    let timeRange = Range(
      start:Int(CGRectGetMinX(frame)),
      end:Int(CGRectGetMaxX(frame)) + 1)

    let vals = timeRange.map { self.source.value(SignalTime($0)) }

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
//  cycle.addLineToPoint(CGPointMake(CGFloat(valCount), CGFloat(values[0])))
  return cycle
}
