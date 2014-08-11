//
//  Spectrum.swift
//  SignalKit
//
//  Created by Rob Napier on 8/5/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

// A path representing the frequency spectrum of a signal over time
public struct SignalSpectrum {
  public let source: SignalSource
  public let sampleTimes: SignalSampleTimes
  public let path : UIBezierPath
  public let values : [CGFloat]
  public init(source: SignalSource, sampleTimes: SignalSampleTimes) {
    self.source = source
    self.sampleTimes = sampleTimes

    self.values = valuesForSource(source, sampleTimes:sampleTimes)
    self.path = pathWithValues(self.values)
  }
}

private func valuesForSource(source: SignalSource, #sampleTimes:SignalSampleTimes) -> [CGFloat] {
  let realLength = countElements(sampleTimes)
  let n2Length = 1 << (Int(log2f(Float(realLength))) + 2)
  let n2Interval = SignalSampleTimes(start: sampleTimes.start, end: n2Length * sampleTimes.stride, sampleRate: sampleTimes.sampleRate)
  let signal = map(n2Interval) { source.output($0).volts }

  return map(spectrumForValues(signal)) { CGFloat($0) }
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
