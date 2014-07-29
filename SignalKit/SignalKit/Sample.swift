//
//  Signal.swift
//  Signal
//
//  Created by Rob Napier on 7/24/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

/*
  A Sample is the value of a Source at a Time, in volts
*/

public struct SignalSample : Comparable, Equatable {
  public let volts: Double
}

// Some helpful constants
public let Volt      = SignalSample(volts: 1.0)
public let Millivolt = Volt / 1000.0

extension SignalSample : DebugPrintable {
  // Fixme: Autoscale
  public var debugDescription: String { return "\(volts)V" }
}

// Voltages are additve
public func +(lhs: SignalSample, rhs: SignalSample) -> SignalSample { return combine(lhs, rhs, +) }
public func -(lhs: SignalSample, rhs: SignalSample) -> SignalSample { return combine(lhs, rhs, -) }

// Voltages can be scaled by a constant
public func *(lhs: SignalSample, rhs: Double)       -> SignalSample { return SignalSample(volts: lhs.volts * rhs) }
public func *(lhs: Double,       rhs: SignalSample) -> SignalSample { return rhs * lhs }
public func /(lhs: SignalSample, rhs: Double)       -> SignalSample { return SignalSample(volts: lhs.volts / rhs) }

// Voltages can be compared
public func <=(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: SignalSample, rhs: SignalSample) -> Bool { return compare(lhs, rhs, <) }

/*
  Private helpers
*/
private func compare(lhs: SignalSample, rhs: SignalSample, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.volts, rhs.volts)
}

private func combine(lhs: SignalSample, rhs: SignalSample, op: (Double, Double) -> Double) -> SignalSample {
  return SignalSample(volts: op(lhs.volts, rhs.volts))
}
