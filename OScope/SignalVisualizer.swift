//
//  SignalOutputGrapher.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

enum VisualizerScale {
  case Absolute(Float)
  case Automatic
}

struct SignalVisualizer {
  let source : SignalSource

  func path(frame:CGRect, xScale:Float = 1, yScale:VisualizerScale = .Absolute(1)) -> UIBezierPath {
    let width  = CGRectGetWidth(frame)

    let timeRange = Range(
      start:SignalTime(CGRectGetMinX(frame)),
      end:SignalTime(CGRectGetMaxX(frame)) + 1)

    let vals = values(timeRange)

    let transform = pathTransform(frame:frame, xScale:xScale, yScale:yScale, values: vals)

    let path = pathWithValues(vals)
    path.applyTransform(transform)
    return path
  }

  func values(range:Range<SignalTime>) -> [SignalValue] {
    // TODO: In Beta3, you can't range over floats
    let intRange = Range<Int>(start:Int(range.startIndex), end:Int(range.endIndex))
    return intRange.map { self.source.value(SignalTime($0)) }
  }

  func automaticYScale(#timeRange:Range<SignalTime>) -> SignalValue {
    return automaticYScale(values:values(timeRange))
  }

  func automaticYScale(#values:[SignalValue]) -> SignalValue {
    return 1/values.map(abs).reduce(0.01, combine: max)
  }

  func pathTransform(#frame: CGRect, xScale:Float, yScale:VisualizerScale, values:[SignalValue]) -> CGAffineTransform {
    let height = CGRectGetHeight(frame)
    let yZero  = CGRectGetMidY(frame)
    let baseScale = -height/2
    let yScaleValue = baseScale * {
      switch yScale {
      case .Absolute(let value): return value
      case .Automatic: return self.automaticYScale(values:values)
      }
    }()

    let transform = CGAffineTransformScale(
      CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
      CGFloat(xScale), CGFloat(yScaleValue))

    return transform
  }
}

func pathWithValues(values:[SignalValue]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    cycle.addLineToPoint(CGPointMake(CGFloat(t), CGFloat(values[t])))
  }
  return cycle
}
