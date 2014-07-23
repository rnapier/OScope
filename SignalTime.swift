//
//  SignalTime.swift
//  OScope
//
//  Created by Rob Napier on 7/23/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

struct SignalTime {
  let value: Int
  let unit : Int

  static let Nanosecond = -9
  static let Microsecond = -6
  static let Millisecond = -3
  static let Second = 1

  func inUnit(unit: Int) -> Double {
    return inPowerOfTen(value: self.value, unit)
  }

  func inNanoseconds() -> Double {
    return self.inUnit(SignalTime.Nanosecond)
  }

  func inMicroseconds() -> Double {
    return self.inUnit(SignalTime.Microsecond)
  }

  func inMilliseconds() -> Double {
    return self.inUnit(SignalTime.Millisecond)
  }
  func inSeconds() -> Double {
    return self.inUnit(SignalTime.Second)
  }
}

extension SignalTime {
  init(seconds: Double, normalizedToFrequency freq:SignalFrequency) {
    self.value = Int(seconds / pow(10, Double(freq.unit)))
    self.unit = Int(-log10(freq.inHertz()))
  }
}

func combine(lhs: SignalTime, rhs: SignalTime, op: (Int, Int) -> Int) -> SignalTime {
  let unit = min(lhs.unit, rhs.unit)
  return SignalTime(value: op(Int(lhs.inUnit(unit)), Int(rhs.inUnit(unit))), unit: unit)
}

func compare(lhs: SignalTime, rhs: SignalTime, op: (Int, Int) -> Bool) -> Bool {
  let unit = min(lhs.unit, rhs.unit)
  return op(Int(lhs.inUnit(unit)), Int(rhs.inUnit(unit)))
}

func +(lhs: SignalTime, rhs: SignalTime) -> SignalTime {
  return combine(lhs, rhs, +)
}

func -(lhs: SignalTime, rhs: SignalTime) -> SignalTime {
  return combine(lhs, rhs, -)
}

func *(lhs: SignalTime, rhs: Int) -> SignalTime {
  return SignalTime(value: lhs.value * rhs, unit: lhs.unit)
}
func *(lhs: Int, rhs: SignalTime) -> SignalTime {
  return rhs * lhs
}
//func *(lhs: SignalTime, rhs: Double) -> SignalTime {
//  return SignalTime(value: (Double(lhs.value) * rhs), unit: lhs.unit)
//}
//func *(lhs: Double, rhs: SignalTime) -> SignalTime {
//  return rhs * lhs
//}


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

extension Int {
  var nanosecond: SignalTime { return SignalTime(value: self, unit: SignalTime.Nanosecond) }
  var nanoseconds: SignalTime { return self.nanosecond }

  var microsecond: SignalTime { return SignalTime(value: self, unit: SignalTime.Microsecond) }
  var microseconds: SignalTime { return self.microsecond }

  var millisecond: SignalTime { return SignalTime(value: self, unit: SignalTime.Millisecond) }
  var milliseconds: SignalTime { return self.millisecond }

  var second: SignalTime { return SignalTime(value: self, unit: SignalTime.Second) }
  var seconds: SignalTime { return self.second }
}

func inPowerOfTen(#value: Int, power: Int) -> Double {
  return Double(value) * log10(Double(power))
}

struct SignalFrequency {
  let value: Int
  let unit : Int

  static let Hertz = 1
  static let Kilohertz = 3
  static let Megahertz = 6
  static let Gigahertz = 9

  func inUnit(unit: Int) -> Double {
    return inPowerOfTen(value: self.value, unit)
  }

  func inHertz() -> Double {
    return self.inUnit(SignalFrequency.Hertz)
  }

  func inKilohertz() -> Double {
    return self.inUnit(SignalFrequency.Kilohertz)
  }

  func inMegahertz() -> Double {
    return self.inUnit(SignalFrequency.Megahertz)
  }

  func inGigahertz() -> Double {
    return self.inUnit(SignalFrequency.Gigahertz)
  }
}

func *(lhs: SignalTime, rhs: SignalFrequency) -> Double {
  return lhs.inSeconds() * rhs.inHertz();
}
func *(lhs: SignalFrequency, rhs: SignalTime) -> Double {
  return rhs * lhs
}
