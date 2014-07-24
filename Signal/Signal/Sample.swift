//
//  Signal.swift
//  Signal
//
//  Created by Rob Napier on 7/24/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

public struct SignalSample : DebugPrintable, Comparable, Equatable {
  public let volts: Double

  static let Volt      = 1.0
  static let Millivolt = Volt / 1000.0

  // Fixme: Autoscale
  public var debugDescription: String { return "\(volts)V" }
}

func combine(lhs: SignalSample, rhs: SignalSample, op: (Double, Double) -> Double) -> SignalSample {
  return SignalSample(volts: op(lhs.volts, rhs.volts))
}

public func +(lhs: SignalSample, rhs: SignalSample) -> SignalSample { return combine(lhs, rhs, +) }
public func -(lhs: SignalSample, rhs: SignalSample) -> SignalSample { return combine(lhs, rhs, -) }

public func *(lhs: SignalSample, rhs: Double)       -> SignalSample { return SignalSample(volts: lhs.volts * rhs) }
public func *(lhs: Double,       rhs: SignalSample) -> SignalSample { return rhs * lhs }

func compare(lhs: SignalSample, rhs: SignalSample, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.volts, rhs.volts)
}

public func <=(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, <) }


public extension Double {
  var volt: SignalSample { return SignalSample(volts: self * SignalSample.Volt) }
  var volts: SignalSample { return self.volt }

  var millivolt: SignalSample { return SignalSample(volts: self * SignalTime.Millisecond) }
  var millivolts: SignalSample { return self.millivolt }
}

public extension Int {
  var volt: SignalSample { return Double(self).volt }
  var volts: SignalSample { return self.volt }

  var millivolt: SignalSample { return Double(self).volt }
  var millivolts: SignalSample { return self.millivolt }
}
