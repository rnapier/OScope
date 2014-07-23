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

func compare(lhs: SignalTime, rhs: SignalTime, op: (Double, Double) -> Bool) -> Bool {
  return op(lhs.seconds, rhs.seconds)
}

func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime {
  return combine(lhs, rhs, +)
}

func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime {
  return combine(lhs, rhs, -)
}

func *(lhs: SignalTime, rhs: Double) -> SignalTime {
  return SignalTime(seconds: lhs.seconds * rhs)
}
func *(lhs: Double, rhs: SignalTime) -> SignalTime {
  return rhs * lhs
}
func *(lhs: SignalTime, rhs: Int) -> SignalTime {
  return lhs * Double(rhs)
}
func *(lhs: Int, rhs: SignalTime) -> SignalTime {
  return rhs * lhs
}

func <=(lhs: SignalTime, rhs: SignalTime) -> Bool {
  return compare(lhs, rhs, <=)
}

func >=(lhs: SignalTime, rhs: SignalTime) -> Bool {
  return compare(lhs, rhs, >=)
}
func >(lhs: SignalTime, rhs: SignalTime) -> Bool {
  return compare(lhs, rhs, >)
}
func ==(lhs: SignalTime, rhs: SignalTime) -> Bool {
  return compare(lhs, rhs, ==)
}
func <(lhs: SignalTime, rhs: SignalTime) -> Bool {
  return compare(lhs, rhs, <)
}

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

func inPowerOfTen(#value: Double, power: Int) -> Double {
  return value * log10(Double(power))
}

struct SignalFrequency {
  let hertz: Double

  static let Hertz = 1
  static let Kilohertz = 1_000
  static let Megahertz = 1_000_000
  static let Gigahertz = 1_000_000_000
}

func *(lhs: SignalTime, rhs: SignalFrequency) -> Double {
  return lhs.seconds * rhs.hertz;
}
func *(lhs: SignalFrequency, rhs: SignalTime) -> Double {
  return rhs * lhs
}
