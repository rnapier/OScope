//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

public class SignalSource {
  public var inputs : [SignalSource] { return [] }
  public func value(time: SignalTime) -> SignalSample { return 0*Volt }
}

public class MixerSource : SignalSource {
  public init(inputs: [SignalSource]) {
    self._inputs = inputs
  }

  public override var inputs : [SignalSource] { return self._inputs }

  public override func value(time: SignalTime) -> SignalSample {
    return self.inputs.map{ $0.value(time) }.reduce(0*Volt, +)
  }

  private let _inputs : [SignalSource]
}

public class ConstantSource : SignalSource {
  public let value : SignalSample

  public init(value: SignalSample) {
    self.value = value
  }

  public override func value(time: SignalTime) -> SignalSample {
    return self.value
  }
}

public typealias Radians = Double

public class SineSource : SignalSource {
  let frequency  : SignalFrequency
  let amplitude  : SignalSample
  let phase      : Radians

  public init(frequency: SignalFrequency, amplitude:SignalSample, phase:Radians) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
  }

  public override func value(time: SignalTime) -> SignalSample {
    let tau = Double(2 * M_PI)
    let ft = self.frequency * time
    let p = self.phase
    let v = self.amplitude * sin(tau * ft + p)

    return v
  }
}
