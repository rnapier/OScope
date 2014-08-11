//
//  WaveForm.swift
//  SignalKit
//
//  Created by Rob Napier on 8/5/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

// A path representing a signal over time
public struct SignalWaveform {
  public let source: SignalSource
  public let sampleTimes: SignalSampleTimes
  public let path : UIBezierPath
  public let values : [CGFloat]

  public init(source: SignalSource, sampleTimes: SignalSampleTimes) {
    self.source = source
    self.sampleTimes = sampleTimes
    
    self.values = map(sampleTimes) { CGFloat(source.output($0).volts) }

    let cycle = UIBezierPath()
    let valCount = self.values.count

    cycle.moveToPoint(CGPointZero)
    for t in 0..<valCount {
      if self.values[t].isFinite {
        let point = CGPointMake(CGFloat(t), min(self.values[t], 10000))
        cycle.addLineToPoint(point)
      }
    }
    self.path = cycle
  }
}
