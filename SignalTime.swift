//
//  SignalTime.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

struct SignalTime {
  let seconds: Double

  static let Nanosecond = 0.000_000_001
  static let Microsecond = 0.000_001
  static let Millisecond = 0.000_1
  static let Second = 1.0
}

func combine(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Double) -> SignalTime {
  return SignalTime(seconds: op(lhs.seconds, rhs.seconds))
}

func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, +) }
func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime { return combine(lhs, rhs, -) }

func *(lhs: SignalTime, rhs: Double)     -> SignalTime { return SignalTime(seconds: lhs.seconds * rhs) }
func *(lhs: Double,     rhs: SignalTime) -> SignalTime { return rhs * lhs }
func *(lhs: SignalTime, rhs: Int)        -> SignalTime { return lhs * Double(rhs) }
func *(lhs: Int,        rhs: SignalTime) -> SignalTime { return rhs * lhs }

func compare(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}

func <=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <=) }
func >=(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >=) }
func > (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, >) }
func ==(lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, ==) }
func < (lhs: SignalTime, rhs: SignalTime) -> Bool { return compare(lhs, rhs, <) }

extension Double {
  var nanosecond: SignalTime { return SignalTime(seconds: self * SignalTime.Nanosecond) }
  var nanoseconds: SignalTime { return self.nanosecond }

  var microsecond: SignalTime { return SignalTime(seconds: self * SignalTime.Microsecond) }
  var microseconds: SignalTime { return self.microsecond }

  var millisecond: SignalTime { return SignalTime(seconds: self * SignalTime.Millisecond) }
  var milliseconds: SignalTime { return self.millisecond }

  var second: SignalTime { return SignalTime(seconds: self) }
  var seconds: SignalTime { return self.second }
}

extension Int {
  var nanosecond: SignalTime { return Double(self).nanosecond }
  var nanoseconds: SignalTime { return self.nanosecond }

  var microsecond: SignalTime { return Double(self).microsecond }
  var microseconds: SignalTime { return self.microsecond }

  var millisecond: SignalTime { return Double(self).millisecond }
  var milliseconds: SignalTime { return self.millisecond }

  var second: SignalTime { return Double(self).second }
  var seconds: SignalTime { return self.second }
}

extension CGFloat {
  var nanosecond: SignalTime { return Double(self).nanosecond }
  var nanoseconds: SignalTime { return self.nanosecond }

  var microsecond: SignalTime { return Double(self).microsecond }
  var microseconds: SignalTime { return self.microsecond }

  var millisecond: SignalTime { return Double(self).millisecond }
  var milliseconds: SignalTime { return self.millisecond }

  var second: SignalTime { return Double(self).second }
  var seconds: SignalTime { return self.second }
}

struct SignalFrequency {
  let hertz: Double

  static let Hertz = 1.0
  static let Kilohertz = 1_000.0
  static let Megahertz = 1_000_000.0
  static let Gigahertz = 1_000_000_000.0
}

func *(lhs: SignalTime,      rhs: SignalFrequency) -> Double { return lhs.seconds * rhs.hertz }
func *(lhs: SignalFrequency, rhs: SignalTime)      -> Double { return rhs * lhs }

extension Double {
  var hertz:     SignalFrequency { return SignalFrequency(hertz: self) }
  var kilohertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Kilohertz) }
  var megahertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Megahertz) }
  var gigahertz: SignalFrequency { return SignalFrequency(hertz: self * SignalFrequency.Gigahertz) }
}

extension Int {
  var hertz:     SignalFrequency { return Double(self).hertz }
  var kilohertz: SignalFrequency { return Double(self).kilohertz }
  var megahertz: SignalFrequency { return Double(self).megahertz }
  var gigahertz: SignalFrequency { return Double(self).gigahertz }
}

extension CGFloat {
  var hertz:     SignalFrequency { return Double(self).hertz }
  var kilohertz: SignalFrequency { return Double(self).kilohertz }
  var megahertz: SignalFrequency { return Double(self).megahertz }
  var gigahertz: SignalFrequency { return Double(self).gigahertz }
}

