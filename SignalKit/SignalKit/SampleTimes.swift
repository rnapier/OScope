//
//  SampleTimes.swift
//  Signal
//
//  Created by Rob Napier on 7/24/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

/*
  A collection of times we would like to sample.
*/
// FIXME: It should be possible to build this with a Stride but most of Strideable is private
public struct SignalSampleTimes : Collection {
  typealias IndexType = Int
  public typealias GeneratorType = GeneratorOf<SignalTime>
  public let startIndex = 0
  public let endIndex: Int

  public subscript(i:Int) -> SignalTime {
    return self.start + (i * self.stride)
  }

  public func generate() -> GeneratorType {
    var current = self.start
    return GeneratorOf {
      if current > self.end {
        return nil
      }
      let result = current
      current = current + self.stride
      return result
    }
  }

  public let start: SignalTime
  public let end: SignalTime
  public let sampleRate : SignalFrequency
  public let stride: SignalTime

  public init(start: SignalTime, end: SignalTime, sampleRate: SignalFrequency) {
    self.start = start
    self.end = end
    self.sampleRate = sampleRate
    self.endIndex = Int((end - start) * sampleRate)
    self.stride = 1.0/Double(self.endIndex) * (end-start)
  }
}
