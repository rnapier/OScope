//
//  WaveForm.swift
//  SignalKit
//
//  Created by Rob Napier on 8/5/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

public class Waveform {
  public let source: SignalSource
  public let sampleTimes: SignalSampleTimes
  public let path : UIBezierPath
  public let values : [CGFloat]

  private init(source: SignalSource, sampleTimes: SignalSampleTimes, values: [CGFloat]) {
    self.source = source
    self.sampleTimes = sampleTimes
    self.values = values

    self.path = {
      let path = UIBezierPath()
      let valCount = values.count

      path.moveToPoint(CGPointZero)
      for t in 0..<valCount {
        if values[t].isFinite {
          let point = CGPointMake(CGFloat(t), min(values[t], 10000))
          path.addLineToPoint(point)
        }
      }
      return path
      }()
  }
}

// A path representing a signal over time
public class SignalWaveform  : Waveform {
  public init(source: SignalSource, sampleTimes: SignalSampleTimes) {
    super.init(source: source, sampleTimes: sampleTimes, values:map(sampleTimes) { CGFloat(source.output($0).volts) })
  }
}

// A path representing the frequency spectrum of a signal over time
public class SpectrumWaveform : Waveform {
  public init(source: SignalSource, sampleTimes: SignalSampleTimes) {

    let realLength = countElements(sampleTimes)
    let n2Length = 1 << (Int(log2f(Float(realLength))) + 2)
    let n2Interval = SignalSampleTimes(start: sampleTimes.start, end: n2Length * sampleTimes.stride, sampleRate: sampleTimes.sampleRate)
    let signal = map(n2Interval) { source.output($0).volts }
    super.init(source: source, sampleTimes: sampleTimes, values: map(spectrumForValues(signal)) { CGFloat($0) })
  }
}
