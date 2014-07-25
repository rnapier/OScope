//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

public protocol SignalSource {
  var inputs:[SignalSource] { get }
  func value(time: SignalTime) -> SignalSample
}

public struct MixerSource : SignalSource {
  public let inputs:[SignalSource]

  public func value(time: SignalTime) -> SignalSample {
    return inputs.map{ $0.value(time) }.reduce(0.volt,+)
  }

  public init(inputs: [SignalSource]) {
    self.inputs = inputs
  }
}

public struct ConstantSource : SignalSource {
  public init(value: SignalSample) {
    self.value = value
  }

  let value : SignalSample

  public var inputs = [SignalSource]()

  public func value(time: SignalTime) -> SignalSample {
    return self.value
  }
}

public typealias Radians = Double

public struct SineSource : SignalSource {
  let frequency  : SignalFrequency
  let amplitude  : SignalSample
  let phase      : Radians

  public init(frequency: SignalFrequency, amplitude:SignalSample, phase:Radians) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
  }

  public let inputs = [SignalSource]()

  public func value(time: SignalTime) -> SignalSample {
    let tau = Double(2 * M_PI)
    let ft = self.frequency * time
    let p = self.phase
    let v = self.amplitude * sin(tau * ft + p)

    return v
  }
}
