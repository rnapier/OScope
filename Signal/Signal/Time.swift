//
//  Time.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

public struct Time : DebugPrintable {
  public let seconds: Double

  static let Second      = 1.0
  static let Millisecond = Second / 1000.0
  static let Microsecond = Millisecond / 1000.0
  static let Nanosecond  = Microsecond / 1000.0

  public var debugDescription: String { return seconds.description }
}

func combine(lhs: Time, rhs: Time, op: (Double, Double) -> Double) -> Time {
  return Time(seconds: op(lhs.seconds, rhs.seconds))
}

public func +(lhs: Time, rhs: Time) -> Time { return combine(lhs, rhs, +) }
public func -(lhs: Time, rhs: Time) -> Time { return combine(lhs, rhs, -) }

public func *(lhs: Time, rhs: Double)     -> Time { return Time(seconds: lhs.seconds * rhs) }
public func *(lhs: Double,     rhs: Time) -> Time { return rhs * lhs }
public func *(lhs: Time, rhs: Int)        -> Time { return lhs * Double(rhs) }
public func *(lhs: Int,        rhs: Time) -> Time { return rhs * lhs }

func compare(lhs: Time, rhs: Time, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}

public func <=(lhs: Time, rhs: Time) -> Bool { return compare(lhs, rhs, <=) }
public func >=(lhs: Time, rhs: Time) -> Bool { return compare(lhs, rhs, >=) }
public func > (lhs: Time, rhs: Time) -> Bool { return compare(lhs, rhs, >) }
public func ==(lhs: Time, rhs: Time) -> Bool { return compare(lhs, rhs, ==) }
public func < (lhs: Time, rhs: Time) -> Bool { return compare(lhs, rhs, <) }

public extension Double {
  var nanosecond: Time { return Time(seconds: self * Time.Nanosecond) }
  var nanoseconds: Time { return self.nanosecond }

  var microsecond: Time { return Time(seconds: self * Time.Microsecond) }
  var microseconds: Time { return self.microsecond }

  var millisecond: Time { return Time(seconds: self * Time.Millisecond) }
  var milliseconds: Time { return self.millisecond }

  var second: Time { return Time(seconds: self) }
  var seconds: Time { return self.second }
}

public extension Int {
  var nanosecond: Time { return Double(self).nanosecond }
  var nanoseconds: Time { return self.nanosecond }

  var microsecond: Time { return Double(self).microsecond }
  var microseconds: Time { return self.microsecond }

  var millisecond: Time { return Double(self).millisecond }
  var milliseconds: Time { return self.millisecond }

  var second: Time { return Double(self).second }
  var seconds: Time { return self.second }
}

public struct SignalFrequency {
  let hertz: Double

  static let Hertz = 1.0
  static let Kilohertz = 1_000.0
  static let Megahertz = 1_000_000.0
  static let Gigahertz = 1_000_000_000.0
}

public func *(lhs: Time,      rhs: SignalFrequency) -> Double { return lhs.seconds * rhs.hertz }
public func *(lhs: SignalFrequency, rhs: Time)      -> Double { return rhs * lhs }

public func /(lhs: Double, rhs: SignalFrequency) -> Time { return Time(seconds: lhs / rhs.hertz) }
public func /(lhs: Double, rhs: Time) -> SignalFrequency { return SignalFrequency(hertz: lhs / rhs.seconds) }

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
