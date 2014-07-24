//
//  SignalOutputGrapher.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

public enum VisualizerScale {
  case Absolute(Float)
  case Automatic
}

public enum VisualizerDomain {
  case Time
  case Frequency
}

public struct Visualizer {
  let source: Source
  let domain: VisualizerDomain
  let frame: CGRect
  let sampleRate: SignalFrequency
  let yScale: VisualizerScale
  let values: [SignalValue]
  let basePath : UIBezierPath

  public var path: UIBezierPath {
  let path = self.basePath.copy() as UIBezierPath
    let transform = pathTransform(frame:self.frame, yScale:self.yScale, values: self.values)
    path.applyTransform(transform)
    return path
  }

  public var automaticYScale : SignalValue {
  return calculateAutomaticYScale(values:values)
  }

  public func withYScale(newYScale:VisualizerScale) -> Visualizer {
    return Visualizer(
      source: self.source,
      domain: self.domain,
      frame: self.frame,
      sampleRate: self.sampleRate,
      yScale: newYScale,
      values: self.values,
      basePath: self.basePath)
  }
}

public extension Visualizer {
  init(source: Source, domain: VisualizerDomain, frame: CGRect, sampleRate: SignalFrequency, yScale: VisualizerScale) {

    let start = 0.seconds
    let end = Double(CGRectGetWidth(frame)) / sampleRate

    let samples = SignalSampleTimes(
      start:start,
      end:end,
      sampleRate:sampleRate
    )

    let vs = valuesForSource(source, sampleTimes:samples, domain: domain)
    let basePath = pathWithValues(vs)

    // FIXME: This still crashes in Beta4
    //    self.init(source: source, domain: domain, frame: frame, xScale: xScale, yScale: yScale, values: vs, basePath: basePath)
    self.source = source
    self.domain = domain
    self.frame = frame
    self.sampleRate = sampleRate
    self.yScale = yScale
    self.values = vs
    self.basePath = basePath
  }
}

public func valuesForSource(source: Source, #sampleTimes:SignalSampleTimes, #domain:VisualizerDomain) -> [SignalValue] {
  switch domain {
  case .Time:
    return map(sampleTimes) { source.value($0) }

  case .Frequency:
    let realLength = countElements(sampleTimes)
    let n2Length = 1 << (Int(log2f(Float(realLength))) + 2)
    let n2Interval = SignalSampleTimes(start: sampleTimes.start, end: n2Length * sampleTimes.stride, sampleRate: sampleTimes.sampleRate)
    let signal = map(n2Interval) { source.value($0) }
    return SpectrumForValues(signal) as [SignalValue]
  }
}

func pathWithValues(values:[SignalValue]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    if values[t].isFinite {
      let point = CGPointMake(CGFloat(t), min(CGFloat(values[t]), 10000))
      cycle.addLineToPoint(point)
    }
  }
  return cycle
}

func calculateAutomaticYScale(#values:[SignalValue]) -> SignalValue {
  return 1/values.map(abs).reduce(0.01, combine: max)
}

func pathTransform(#frame: CGRect, #yScale:VisualizerScale, #values:[SignalValue]) -> CGAffineTransform {
  let height = CGRectGetHeight(frame)
  let yZero  = CGRectGetMidY(frame)
  let baseScale = -height/2
  let yScaleValue: CGFloat = baseScale * {
    switch yScale {
    case .Absolute(let value): return CGFloat(value)
    case .Automatic: return CGFloat(calculateAutomaticYScale(values:values))
    }
    }()

  let transform = CGAffineTransformScale(
    CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
    1.0, CGFloat(yScaleValue))
  
  return transform
}
