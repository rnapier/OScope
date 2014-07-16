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
//    let period = Int(source.periodLength)

    let width  = CGRectGetWidth(bounds)
    let height = CGRectGetHeight(bounds)

    let yZero  = CGRectGetMidY(bounds)
    let xScale = CGFloat(1)
    let yScale = -height/2

    let transform = CGAffineTransformScale(
      CGAffineTransformMakeTranslation(0, yZero),
      xScale, yScale)

    let vals = (0..<Int(width)).map { self.source.value(SignalTime($0)) }

    let cyclePath = cyclePathWithValues(vals)
    cyclePath.applyTransform(transform)
    return cyclePath
//    var fullPath = pathFromHorizontallyRepeatedCycle(cyclePath, totalWidth:width)
//    fullPath.applyTransform(transform)
//    return fullPath
  }
}

func cyclePathWithValues(values:[SignalValue]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    cycle.addLineToPoint(CGPointMake(CGFloat(t), CGFloat(values[t])))
  }
  cycle.addLineToPoint(CGPointMake(CGFloat(valCount), CGFloat(values[0])))
  return cycle
}


func pathFromHorizontallyRepeatedCycle(cycle: UIBezierPath, #totalWidth:CGFloat) -> UIBezierPath {
  let cycleOffset = CGAffineTransformMakeTranslation(cycle.bounds.width, 0)
  let path = UIBezierPath()
  do {
    path.appendPath(cycle)
    cycle.applyTransform(cycleOffset)
  } while path.currentPoint.x < totalWidth
  return path
}
