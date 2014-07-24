//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

public typealias SignalValue = Float

// FIXME: It should be possible to build this with a Stride
public struct SignalSampleTimes : Collection {
  typealias IndexType = Int
  public typealias GeneratorType = GeneratorOf<Time>
  public let startIndex = 0
  public let endIndex: Int

  public subscript(i:Int) -> Time {
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

  let start: Time
  let end: Time
  let sampleRate : SignalFrequency
  var stride: Time

  public init(start: Time, end: Time, sampleRate: SignalFrequency) {
    self.start = start
    self.end = end
    self.sampleRate = sampleRate
    self.endIndex = Int((end - start) * sampleRate)
    self.stride = 1.0/Double(self.endIndex) * (end-start)
  }
}

public protocol Source {
  var inputs:[Source] { get }
  func value(time: Time) -> SignalValue
}

public struct MixerSource : Source {
  public let inputs:[Source]

  public func value(time: Time) -> SignalValue {
    return inputs.map{ $0.value(time) }.reduce(0,+)
  }

  public init(inputs: [Source]) {
    self.inputs = inputs
  }
}

public struct ConstantSource : Source {
  public init(value: SignalValue) {
    self.value = value
  }

  let value : SignalValue

  public var inputs = [Source]()

  public func value(time: Time) -> SignalValue {
    return self.value
  }
}

public typealias Radians = Double

public struct SineSource : Source {
  let frequency  : SignalFrequency
  let amplitude  : SignalValue
  let phase      : Radians

  public init(frequency: SignalFrequency, amplitude:SignalValue, phase:Radians) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
  }

  public let inputs = [Source]()

  public func value(time: Time) -> SignalValue {
    let tau = Double(2 * M_PI)
    let ft = self.frequency * time
    let p = self.phase
    let v = Double(self.amplitude) * sin(tau * ft + p)

    return SignalValue(v)
  }
}
