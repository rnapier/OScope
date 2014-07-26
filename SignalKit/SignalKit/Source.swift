//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

public class SignalSource {
  public let inputs = [SignalSource]()
  public func value(time: SignalTime) -> SignalSample { return 0*Volt }

  public init() {}

  public init(inputs: [SignalSource]) {
    self.inputs = inputs
  }
}

public class MixerSource : SignalSource {
  public init(inputs: [SignalSource]) {
    super.init(inputs: inputs)
  }

  public override func value(time: SignalTime) -> SignalSample {
    return inputs.map{ $0.value(time) }.reduce(0*Volt,+)
  }
}

public class ConstantSource : SignalSource {
  public let value : SignalSample

  public init(value: SignalSample) {
    self.value = value
    super.init()
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
    super.init()
  }

  public override func value(time: SignalTime) -> SignalSample {
    let tau = Double(2 * M_PI)
    let ft = self.frequency * time
    let p = self.phase
    let v = self.amplitude * sin(tau * ft + p)

    return v
  }
}
