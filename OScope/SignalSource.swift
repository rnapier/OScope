//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

typealias SignalTime = Float
typealias SignalValue = Float

// FIXME: It should be possible to build this with a Stride
struct SignalInterval : Collection {
  typealias IndexType = Int
  typealias GeneratorType = GeneratorOf<SignalTime>
  internal let startIndex: IndexType = 0
  internal let endIndex: IndexType
  subscript(i:IndexType) -> SignalTime {
    return start + SignalTime(i) * stride
  }

  func generate() -> GeneratorType {
    var current = start
    return GeneratorOf {
      if current > self.end {
        return nil
      }
      let result = current
      current += self.stride
      return result
    }
  }

  let start: SignalTime
  let end: SignalTime
  let stride: SignalTime = 1.0

  init(start: SignalTime, end: SignalTime) {
    self.start = start
    self.end = end
    self.endIndex = Int((end - start) / stride)
  }

  init(start: SignalTime, count: Int) {
    self.init(start: start, end: start + SignalTime(count))
  }
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
  let value : SignalValue

  var inputs : [SignalSource] { get { return [] } }

  func value(time: SignalTime) -> SignalValue {
    return value
  }
}

struct SineSource : SignalSource {
  let frequency  : SignalTime
  let amplitude  : SignalValue
  let phase      : SignalTime
  let sampleRate : SignalTime

  // FIXME: Why is this init required?
  init(frequency: SignalTime, amplitude:SignalValue, phase:SignalTime, sampleRate:SignalTime) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
    self.sampleRate = sampleRate
  }

  let inputs = [SignalSource]()

  func value(time: SignalTime) -> SignalValue {
    let tau = Float(2 * M_PI)
    let tau_ft = tau * Float(frequency*time)/Float(sampleRate)
    let p = Float(phase)
    let v = Float(amplitude) * sinf(tau_ft + p)

    return SignalValue(v)
  }
}

