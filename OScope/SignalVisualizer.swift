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

  var path: UIBezierPath {
  let path = self.basePath.copy() as UIBezierPath
    println(self.frame)
    let transform = pathTransform(frame:self.frame, xScale:self.xScale, yScale:self.yScale, values: self.values)
    path.applyTransform(transform)
    return path
  }

  var automaticYScale : SignalValue {
  return calculateAutomaticYScale(values:values)
  }

  func withYScale(newYScale:VisualizerScale) -> SignalVisualizer {
    return SignalVisualizer(
      source: self.source,
      domain: self.domain,
      frame: self.frame,
      xScale: self.xScale,
      yScale: newYScale,
      values: self.values,
      basePath: self.basePath)
  }
}

extension SignalVisualizer {
  init(source: SignalSource, domain: VisualizerDomain, frame: CGRect, xScale: Float, yScale: VisualizerScale) {
    let samples = SignalSampleTimes(
      start:0.seconds,
      end:(CGRectGetWidth(frame) / CGFloat(xScale)).seconds,
      sampleRate: SignalFrequency(hertz: 44100.0) // FIXME: configure sample rate
    )

    let vs = valuesForSource(source, sampleTimes:samples, domain: domain)
    let basePath = pathWithValues(vs)

    // FIXME: This still crashes in Beta4
    //    self.init(source: source, domain: domain, frame: frame, xScale: xScale, yScale: yScale, values: vs, basePath: basePath)
    self.source = source
    self.domain = domain
    self.frame = frame
    self.xScale = xScale
    self.yScale = yScale
    self.values = vs
    self.basePath = basePath
  }
}

func valuesForSource(source: SignalSource, #sampleTimes:SignalSampleTimes, #domain:VisualizerDomain) -> [SignalValue] {
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
    case .Absolute(let value): return CGFloat(value)
    case .Automatic: return CGFloat(calculateAutomaticYScale(values:values))
    }
    }()

  let transform = CGAffineTransformScale(
    CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
    CGFloat(xScale), CGFloat(yScaleValue))

  return transform
}
