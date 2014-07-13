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

protocol SignalSource {
  var periodLength : SignalTime { get }
  func value(time: SignalTime) -> SignalValue
}

struct MixerSource : SignalSource {
  let inputs:[SignalSource]

  var periodLength : SignalTime { get { return SignalTime(lcm(inputs.map{ Int(round($0.periodLength)) })) } }

  func value(time: SignalTime) -> SignalValue {
    return inputs.map{ $0.value(time) }.reduce(0,+)
  }
}

struct ConstantSource : SignalSource {
  let value:SignalValue
  let periodLength = SignalTime(1)

  init(_ value:SignalValue) {
    self.value = value
  }

  func value(time: SignalTime) -> SignalValue {
    return value
  }
}

struct SineSource : SignalSource {
  let frequency  : SignalTime
  let amplitude  : SignalValue
  let phase      : SignalTime
  let sampleRate : SignalTime

  var periodLength : SignalTime { get { return sampleRate/frequency } }

  func value(time: SignalTime) -> SignalValue {
    let tau = Float(2 * M_PI)
    let tau_ft = tau * Float(frequency*time)/Float(sampleRate)
    let p = Float(phase)
    let v = Float(amplitude) * sinf(tau_ft + p)

    return SignalValue(v)
  }
}
