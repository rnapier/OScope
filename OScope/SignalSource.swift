//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

typealias SignalValue = Float

// FIXME: It should be possible to build this with a Stride
struct SignalSampleTimes : Collection {
  typealias IndexType = Int
  typealias GeneratorType = GeneratorOf<SignalTime>
  internal let startIndex = 0
  internal let endIndex: Int

  subscript(i:Int) -> SignalTime {
    return self.start + (i * self.stride)
  }

  func generate() -> GeneratorType {
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

  let start: SignalTime
  let end: SignalTime
  let sampleRate : SignalFrequency
  var stride: SignalTime

  init(start: SignalTime, end: SignalTime, sampleRate: SignalFrequency) {
    self.start = start
    self.end = end
    self.sampleRate = sampleRate
    self.endIndex = Int((end - start) * sampleRate)

    self.stride = SignalTime(seconds: Double(self.endIndex - 1) / sampleRate.hertz)
  }

//  init(start: SignalTime, count: Int, sampleRate: SignalFrequency) {
//    self.init(start: start, end: start + SignalTime(count))
//  }
}

protocol SignalSource {
  var inputs:[SignalSource] { get }
  func value(time: SignalTime) -> SignalValue
}

struct MixerSource : SignalSource {
  let inputs:[SignalSource]

  func value(time: SignalTime) -> SignalValue {
    return inputs.map{ $0.value(time) }.reduce(0,+)
  }
}

struct ConstantSource : SignalSource {
  init(value: SignalValue) {
    self.value = value
  }

  let value : SignalValue

  var inputs = [SignalSource]()

  func value(time: SignalTime) -> SignalValue {
    return self.value
  }
}

typealias Radians = Double

struct SineSource : SignalSource {
  let frequency  : SignalFrequency
  let amplitude  : SignalValue
  let phase      : Radians

  init(frequency: SignalFrequency, amplitude:SignalValue, phase:Radians) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
  }

  let inputs = [SignalSource]()

  func value(time: SignalTime) -> SignalValue {
    let tau = Double(2 * M_PI)
    let ft = self.frequency * time
    let p = self.phase
    let v = Double(self.amplitude) * sin(tau * ft + p)

    return SignalValue(v)
  }
}
