//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

/*
A SignalSource provides values over time.
*/
public class SignalSource {
  public let inputs : [SignalSource]

  public let value : (SignalTime -> SignalSample)

  public init(inputs: [SignalSource] = [], function: (SignalTime -> SignalSample)) {
    self.inputs = inputs
    self.value = function
  }
}

public class MixerSource : SignalSource {
  public init(inputs: [SignalSource]) {
    super.init(
      inputs: inputs,
      function: { time in
        inputs.map{ $0.value(time) }.reduce(0*Volt, +)
      }
    )
  }
}

public class ConstantSource : SignalSource {
  public var constantValue : SignalSample { return self.value(0*Second) }

  public init(value: SignalSample) {
    super.init(
      function: { _ in value }
    )
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

    super.init(
      function: { time in
        let tau = Double(2 * M_PI)
        let ft = frequency * time
        let p = phase
        let v = amplitude * sin(tau * ft + p)
        return v
      }
    )
  }
}
