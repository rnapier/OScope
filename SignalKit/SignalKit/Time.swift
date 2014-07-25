//
//  SignalTime.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

public struct SignalTime : DebugPrintable, Comparable, Equatable {
  public let seconds: Double

  static let Second      = 1.0
  static let Millisecond = Second / 1000.0
  static let Microsecond = Millisecond / 1000.0
  static let Nanosecond  = Microsecond / 1000.0

  // FIXME: Autoscale
  public var debugDescription: String { return "\(seconds)s" }
}

func combine(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Double) -> SignalTime {
  return SignalTime(seconds: op(lhs.seconds, rhs.seconds))
}

public func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, +) }
public func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, -) }

public func *(lhs: SignalTime, rhs: Double)     -> SignalTime { return SignalTime(seconds: lhs.seconds * rhs) }
public func *(lhs: Double,     rhs: SignalTime) -> SignalTime { return rhs * lhs }
public func *(lhs: SignalTime, rhs: Int)        -> SignalTime { return lhs * Double(rhs) }
public func *(lhs: Int,        rhs: SignalTime) -> SignalTime { return rhs * lhs }

func compare(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}

public func <=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <) }

public extension Int {
  var nanosecond: SignalTime { return SignalTime(seconds: Double(self) * SignalTime.Nanosecond) }
  var nanoseconds: SignalTime { return self.nanosecond }

  var microsecond: SignalTime { return SignalTime(seconds: Double(self) * SignalTime.Microsecond) }
  var microseconds: SignalTime { return self.microsecond }

  var millisecond: SignalTime { return SignalTime(seconds: Double(self) * SignalTime.Millisecond) }
  var milliseconds: SignalTime { return self.millisecond }

  var second: SignalTime { return SignalTime(seconds: Double(self) * SignalTime.Second) }
  var seconds: SignalTime { return self.second }
}

public struct SignalFrequency {
  let hertz: Double

  static let Hertz = 1.0
  static let Kilohertz = 1_000.0
  static let Megahertz = 1_000_000.0
  static let Gigahertz = 1_000_000_000.0
}

public func *(lhs: SignalTime,      rhs: SignalFrequency) -> Double { return lhs.seconds * rhs.hertz }
public func *(lhs: SignalFrequency, rhs: SignalTime)      -> Double { return rhs * lhs }

public func /(lhs: Double, rhs: SignalFrequency) -> SignalTime { return SignalTime(seconds: lhs / rhs.hertz) }
public func /(lhs: Double, rhs: SignalTime) -> SignalFrequency { return SignalFrequency(hertz: lhs / rhs.seconds) }

extension Double {
  var hertz:     SignalFrequency { return SignalFrequency(hertz: self) }
  var kilohertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Kilohertz) }
  var megahertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Megahertz) }
  var gigahertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Gigahertz) }
}

public extension Int {
  var hertz:     SignalFrequency { return Double(self).hertz }
  var kilohertz: SignalFrequency { return Double(self).kilohertz }
  var megahertz: SignalFrequency { return Double(self).megahertz }
  var gigahertz: SignalFrequency { return Double(self).gigahertz }
}
