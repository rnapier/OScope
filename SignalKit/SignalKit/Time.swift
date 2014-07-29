//
//  SignalTime.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

/*
  A Time is a moment when we want a Sample. Its reciprocal is Frequency.
  These types ensure that units are only combined in legal ways.
*/

public struct SignalTime : Comparable, Equatable {
  public let seconds: Double
}

// Some helpful constants
public let Second      = SignalTime(seconds: 1.0)
public let Millisecond = Second / 1000.0
public let Microsecond = Millisecond / 1000.0
public let Nanosecond  = Microsecond / 1000.0

extension SignalTime : DebugPrintable {
  // Fixme: Autoscale
  public var debugDescription: String { return "\(seconds)s" }
}

// Time is additive
public func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, +) }
public func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, -) }

// Time can be scaled by a constant
public func *(lhs: SignalTime, rhs: Double)     -> SignalTime { return SignalTime(seconds: lhs.seconds * rhs) }
public func *(lhs: Double,     rhs: SignalTime) -> SignalTime { return rhs * lhs }
public func *(lhs: SignalTime, rhs: Int)        -> SignalTime { return lhs * Double(rhs) }
public func *(lhs: Int,        rhs: SignalTime) -> SignalTime { return rhs * lhs }
public func /(lhs: SignalTime, rhs: Double)     -> SignalTime { return SignalTime(seconds: lhs.seconds / rhs) }

// Time can be compared
public func <=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <) }

// Private helpers
private func combine(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Double) -> SignalTime {
  return SignalTime(seconds: op(lhs.seconds, rhs.seconds))
}

private func compare(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}


/*
  Frequency is the reciprocol of Time
*/

public struct SignalFrequency {
  let hertz: Double
}

// Some useful constants
public let Hertz = SignalFrequency(hertz: 1.0)
public let Kilohertz = 1000 * Hertz
public let Megahertz = 1000 * Kilohertz
public let Gigahertz = 1000 * Megahertz

// Frequency and Time are reciprocols
public func *(lhs: SignalTime,      rhs: SignalFrequency) -> Double { return lhs.seconds * rhs.hertz }
public func *(lhs: SignalFrequency, rhs: SignalTime)      -> Double { return rhs * lhs }

public func /(lhs: Double, rhs: SignalFrequency) -> SignalTime { return SignalTime(seconds: lhs / rhs.hertz) }
public func /(lhs: Double, rhs: SignalTime)      -> SignalFrequency { return SignalFrequency(hertz: lhs / rhs.seconds) }

// Frequency can be scaled by a constant
public func *(lhs: SignalFrequency, rhs: Double)          -> SignalFrequency { return SignalFrequency(hertz: lhs.hertz * rhs) }
public func *(lhs: Double,          rhs: SignalFrequency) -> SignalFrequency { return rhs * lhs }

