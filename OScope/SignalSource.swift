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
  var inputs:[SignalSource] { get }
  var periodLength : SignalTime { get }
  func value(time: SignalTime) -> SignalValue
}

struct MixerSource : SignalSource {
  let inputs:[SignalSource]

  var periodLength : SignalTime {
  println(self, "periodLength start");
    let val = SignalTime(lcm(self.inputs.map{ Int(round($0.periodLength)) } ) )
    println(self, "periodLength stop"); return val }
//  var result : SignalTime?
//    return {
//      if !result {
//        println("periodLength")
//        result = SignalTime(lcm(self.inputs.map{ Int(round($0.periodLength)) } ) )
//      }
//      return result!
//      }()
//  }

  func value(time: SignalTime) -> SignalValue {
    println(self, time)
    return inputs.map{ $0.value(time) }.reduce(0,+)
  }
}

struct ConstantSource : SignalSource {
  let value : SignalValue

  // FIXME: Why is this init required?
  init (_ value: SignalValue) {
    self.value = value
  }

  var periodLength : SignalTime { return SignalTime(1) }
  let inputs = [SignalSource]()

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
  var periodLength : SignalTime { return sampleRate/frequency }

  func value(time: SignalTime) -> SignalValue {
    let tau = Float(2 * M_PI)
    let tau_ft = tau * Float(frequency*time)/Float(sampleRate)
    let p = Float(phase)
    let v = Float(amplitude) * sinf(tau_ft + p)

    return SignalValue(v)
  }
}

