//
//  SignalOutputGrapher.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

/*
  A Visualizer creates visualization paths (UIBezierPath) for a
  Signal within a frame (CGRect) in the time or frequency domains.
*/

import UIKit

public enum VisualizerScale {
  case Absolute(Float)
  case Automatic
}

public enum VisualizerDomain {
  case Time
  case Frequency
}

public struct SignalVisualizer {
  let source: SignalSource
  let domain: VisualizerDomain
  let frame: CGRect
  let sampleRate: SignalFrequency
  let yScale: VisualizerScale
  public let values: [CGFloat]
  let basePath : UIBezierPath

  public var path: UIBezierPath {
  let path = self.basePath.copy() as UIBezierPath
    let transform = pathTransform(frame:self.frame, yScale:self.yScale, values:self.values)
    path.applyTransform(transform)
    return path
  }

  public var automaticYScale : CGFloat { return calculateAutomaticYScale(values:self.values) }

  public func withYScale(newYScale:VisualizerScale) -> SignalVisualizer {
    return SignalVisualizer(
      source: self.source,
      domain: self.domain,
      frame: self.frame,
      sampleRate: self.sampleRate,
      yScale: newYScale,
      values: self.values,
      basePath: self.basePath)
  }
}

public extension SignalVisualizer {
  init(source: SignalSource, domain: VisualizerDomain, frame: CGRect, sampleRate: SignalFrequency, yScale: VisualizerScale) {

    let start:SignalTime = 0*Second
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

private func valuesForSource(source: SignalSource, #sampleTimes:SignalSampleTimes, #domain:VisualizerDomain) -> [CGFloat] {
  switch domain {
  case .Time:
    return map(sampleTimes) { CGFloat(source.output($0).volts) }

  case .Frequency:
    let realLength = countElements(sampleTimes)
    let n2Length = 1 << (Int(log2f(Float(realLength))) + 2)
    let n2Interval = SignalSampleTimes(start: sampleTimes.start, end: n2Length * sampleTimes.stride, sampleRate: sampleTimes.sampleRate)
    let signal = map(n2Interval) { source.output($0).volts }

    return map(spectrumForValues(signal)) { CGFloat($0) }
  }
}

private func pathWithValues(values:[CGFloat]) -> UIBezierPath {
  let cycle = UIBezierPath()
  let valCount = values.count

  cycle.moveToPoint(CGPointZero)
  for t in 0..<valCount {
    if values[t].isFinite {
      let point = CGPointMake(CGFloat(t), min(values[t], 10000))
      cycle.addLineToPoint(point)
    }
  }
  return cycle
}

private func calculateAutomaticYScale(#values:[CGFloat]) -> CGFloat {
  return 1/values.map(abs).reduce(CGFloat(DBL_EPSILON), combine: max) // FIXME: DBL_EPSILON could become 0 if CGFloat is Float
}

private func pathTransform(#frame: CGRect, #yScale:VisualizerScale, #values:[CGFloat]) -> CGAffineTransform {
  let height = CGRectGetHeight(frame)
  let yZero  = CGRectGetMidY(frame)
  let baseScale = -height/2
  let yScaleValue: CGFloat = baseScale * {
    switch yScale {
    case .Absolute(let value): return CGFloat(value)
    case .Automatic: return calculateAutomaticYScale(values:values)
    }
    }()

  let transform = CGAffineTransformScale(
    CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
    1.0, CGFloat(yScaleValue))
  
  return transform
}
