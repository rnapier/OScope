//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Darwin

/*
  A Source provides values over time. It is just a function with
  input Sources and an output Sample (a Sample is the value of a Source
  at a Time). Samples are pull-driven; they do not generate (push) values.
  They compute values when requested.
*/

//TODO: Add output gain
public class SignalSource {
  public let inputs : [SignalSource]

  public let output : (SignalTime -> SignalSample)

  public init(inputs: [SignalSource] = [], function: (SignalTime -> SignalSample)) {
    self.inputs = inputs
    self.output = function
  }
}

/*
  Mixers sum their inputs
*/

//TODO: Add input gain
public class MixerSource : SignalSource {
  public init(inputs: [SignalSource]) {
    super.init(
      inputs: inputs,
      function: { time in
        inputs.map{ $0.output(time) }.reduce(0*Volt, +)
      }
    )
  }
}

/*
  Constant sources are constant
*/
public class ConstantSource : SignalSource {
  public var constantValue : SignalSample { return self.output(0*Second) }

  public init(value: SignalSample) {
    super.init(
      function: { _ in value }
    )
  }
}

/*
  Sine sources generate a sine wave over time
*/

public typealias Radians = Double // FIXME: Is this helpful? It should probably be somewhere else.

public class SineSource : SignalSource {
  public let frequency  : SignalFrequency
  public let amplitude  : SignalSample
  public let phase      : Radians

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
