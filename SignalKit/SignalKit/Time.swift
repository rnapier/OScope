//
//  SignalTime.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

public struct SignalTime : DebugPrintable, Comparable, Equatable {
  public let seconds: Double

  // FIXME: Autoscale
  public var debugDescription: String { return "\(seconds)s" }
}

public let Second      = SignalTime(seconds: 1.0)
public let Millisecond = Second / 1000.0
public let Microsecond = Millisecond / 1000.0
public let Nanosecond  = Microsecond / 1000.0

private func combine(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Double) -> SignalTime {
  return SignalTime(seconds: op(lhs.seconds, rhs.seconds))
}

public func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, +) }
public func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, -) }

public func *(lhs: SignalTime, rhs: Double)     -> SignalTime { return SignalTime(seconds: lhs.seconds * rhs) }
public func *(lhs: Double,     rhs: SignalTime) -> SignalTime { return rhs * lhs }
public func *(lhs: SignalTime, rhs: Int)        -> SignalTime { return lhs * Double(rhs) }
public func *(lhs: Int,        rhs: SignalTime) -> SignalTime { return rhs * lhs }

public func /(lhs: SignalTime, rhs: Double) -> SignalTime { return SignalTime(seconds: lhs.seconds / rhs) }

private func compare(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}

public func <=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <) }

public struct SignalFrequency {
  let hertz: Double
}

public let Hertz = SignalFrequency(hertz: 1.0)
public let Kilohertz = 1000 * Hertz
public let Megahertz = 1000 * Kilohertz
public let Gigahertz = 1000 * Megahertz

public func *(lhs: SignalTime,      rhs: SignalFrequency) -> Double { return lhs.seconds * rhs.hertz }
public func *(lhs: SignalFrequency, rhs: SignalTime)      -> Double { return rhs * lhs }

public func *(lhs: SignalFrequency, rhs: Double)          -> SignalFrequency { return SignalFrequency(hertz: lhs.hertz * rhs) }
public func *(lhs: Double,          rhs: SignalFrequency) -> SignalFrequency { return rhs * lhs }

public func /(lhs: Double, rhs: SignalFrequency) -> SignalTime { return SignalTime(seconds: lhs / rhs.hertz) }
public func /(lhs: Double, rhs: SignalTime) -> SignalFrequency { return SignalFrequency(hertz: lhs / rhs.seconds) }
