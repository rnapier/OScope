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

enum VisualizerDomain {
  case Time
  case Frequency
}

struct SignalVisualizer {
  let source: SignalSource
  let domain: VisualizerDomain
  let frame: CGRect
  let xScale: Float
  let yScale: VisualizerScale
  let values: [SignalValue]
  let basePath : UIBezierPath

  var path : UIBezierPath {
    let path = basePath.copy() as UIBezierPath
    let transform = pathTransform(frame:frame, xScale:xScale, yScale:yScale, values: values)
    path.applyTransform(transform)
    return path
  }

  var automaticYScale : SignalValue {
  return calculateAutomaticYScale(values:values)
  }

  func withYScale(newYScale:VisualizerScale) -> SignalVisualizer {
    return SignalVisualizer(source: source, domain: domain, frame: frame, xScale: xScale, yScale: newYScale, values: values, basePath: basePath)
  }
}

extension SignalVisualizer {
  init(source: SignalSource, domain: VisualizerDomain, frame: CGRect, xScale: Float, yScale: VisualizerScale) {
    let timeRange = Range(
      start:SignalTime(CGRectGetMinX(frame)),
      end:SignalTime(CGRectGetMaxX(frame)) + 1)

    let vs = valuesForSource(source, timeRange:timeRange, domain: domain)

    // FIXME: I should be able to use self.init(...) here (crashes in Beta3)
    //        self.init(source: source, frame: frame, xScale: xScale, yScale: yScale, values: vs)
    self.source = source
    self.domain = domain
    self.frame = frame
    self.xScale = xScale
    self.yScale = yScale
    self.values = vs

    basePath = pathWithValues(self.values)
  }
}

func valuesForSource(source: SignalSource, #timeRange:Range<SignalTime>, #domain:VisualizerDomain) -> [SignalValue] {
  // TODO: In Beta3, you can't range over floats
  switch domain {
  case .Time:
    let intRange = Range<Int>(start:Int(timeRange.startIndex), end:Int(timeRange.endIndex))
    let signal = intRange.map { source.value(SignalTime($0)) }
    return signal
  case .Frequency:
    // FIXME: This is kind of hackish
    // Expand range to one more than the next power of 2 (one to cover the desired time, and a second so we'll have enough points to cover the whole frame)
    let realLength = timeRange.endIndex - timeRange.startIndex
    let n2Length = 1 << (Int(log2f(Float(realLength))) + 2)
    let intRange = Range<Int>(start:Int(timeRange.startIndex), end:Int(timeRange.startIndex) + Int(n2Length))
    let signal = intRange.map { source.value(SignalTime($0)) }
    return SpectrumForValues(signal) as [SignalValue]
  }
}

func pathWithValues(values:[SignalValue]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    if values[t].isFinite && values[t] < 10000 {
      cycle.addLineToPoint(CGPointMake(CGFloat(t), min(CGFloat(values[t]), 10000)))
    }
  }
  return cycle
}

func calculateAutomaticYScale(#values:[SignalValue]) -> SignalValue {
  return 1/values.map(abs).reduce(0.01, combine: max)
}

func pathTransform(#frame: CGRect, #xScale:Float, #yScale:VisualizerScale, #values:[SignalValue]) -> CGAffineTransform {
  let height = CGRectGetHeight(frame)
  let yZero  = CGRectGetMidY(frame)
  let baseScale = -height/2
  let yScaleValue = baseScale * {
    switch yScale {
    case .Absolute(let value): return value
    case .Automatic: return calculateAutomaticYScale(values:values)
    }
    }()

  let transform = CGAffineTransformScale(
    CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
    CGFloat(xScale), CGFloat(yScaleValue))

  return transform
}
