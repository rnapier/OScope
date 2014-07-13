// Playground - noun: a place where people can play

import Darwin

//
//  lcm.swift
//  OScope
//
//  Created by Rob Napier on 7/11/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

func forAll<E, C: Swift.Collection, L: LogicValue
  where C.IndexType: ForwardIndex,
  E == C.GeneratorType.Element>
  (c: C, predicate: (E) -> L) -> Bool {
    for e in c {
      if (!predicate(e)) {
        return false
      }
    }
    return true
}

func allEqual<C:Collection, E: Equatable
  where C.IndexType: ForwardIndex,
  E == C.GeneratorType.Element>
  (collection: C, element:E) -> Bool {
    return forAll(collection) { $0 == element }
}

func boundsOf<C: Swift.Collection>(c: C) -> Range<C.IndexType> {
  return c.startIndex..<c.endIndex
}

/// Return the index of the minimum element in a collection (as defined
/// by a binary predicate) starting from a given point.  Empty
/// collections return nil.  In case of duplicate minima, returns
/// the index of the first in the collection.
//
// Named minElementAt to avoid confusion with Swift.minElement,
// which takes a sequence and returns the minimum value
//
// Returning an optional is kind of annoying but that's the
// best way if the collection could be empty.  Swift.minElement
// generates a fatal error in this case.
func minElementAt<C: Swift.Collection, L: LogicValue>
  (domain: C, var bounds: Range<C.IndexType>, pred: (C.GeneratorType.Element,C.GeneratorType.Element)->L)
  -> C.IndexType? {

    if bounds.isEmpty { return nil }

    // this is a little ugly but it seems the best way to
    // seed the initial minimum value
    var min_idx = bounds.startIndex
    var min_so_far = domain[min_idx]
    // skip the first value since it's the seed candidate
    bounds.startIndex++

    for idx in bounds {
      let new_candidate = domain[idx]
      if pred(new_candidate, min_so_far) {
        min_so_far = new_candidate
        min_idx = idx
      }
    }

    return min_idx
}

/// Return the index of the minimum element (as defined by a
/// binary predicate).  Empty collections return nil.
func minElementAt<E, C: Swift.Collection, L: LogicValue
  where E == C.GeneratorType.Element>
  (domain: C, pred: (C.GeneratorType.Element, C.GeneratorType.Element)->L)
  -> C.IndexType? {
    return minElementAt(domain, boundsOf(domain), pred)
}

/// Return the index of the minimum element.  Empty collections return nil.
func minElementAt<C: Swift.Collection where C.GeneratorType.Element: Comparable>
  (domain: C, bounds: Range<C.IndexType>)
  -> C.IndexType? {

    // Should just be able to pass < instead of { $0 < $1 }
    // but this currently crashes the compiler
    return minElementAt(domain, bounds, { $0 < $1 })
}

/// Return the index of the minimum element.  Empty collections return nil
func minElementAt<C: Swift.Collection where C.GeneratorType.Element: Comparable>
  (domain: C)
  -> C.IndexType? {
    return minElementAt(domain, boundsOf(domain),  { $0 < $1 })
}


func lcm(xs:[Int]) -> Int {
  assert(forAll(xs, { $0 > 0 }), "All values must be positive")

  var accums = xs

  while !allEqual(accums, accums[0]) {
    if let m = minElementAt(accums) {
      accums[m] += xs[m]
    } else {
      assert(false, "BUG: every non-empty collection should have a minimum")
    }

  }
  return accums[0]
}

typealias SignalTime = Float
typealias SignalValue = Float

protocol SignalSource {
  var periodLength : SignalTime { get }
  func value(time: SignalTime) -> SignalValue
}

struct MixerSource : SignalSource {
  let inputs:[SignalSource]

  var periodLength : SignalTime { get { return SignalTime(lcm(inputs.map{ Int(round($0.periodLength)) })) } }

  func value(time: SignalTime) -> SignalValue {
    return inputs.map{ $0.value(time) }.reduce(0,+)
  }
}


struct ConstantSource : SignalSource {
  let value:SignalValue
  let periodLength = SignalTime(1)

  init(_ value:SignalValue) {
    self.value = value
  }

  func value(time: SignalTime) -> SignalValue {
    return value
  }
}

struct SineSource : SignalSource {
  let frequency : SignalTime
  let amplitude : SignalValue
  let phase : SignalTime
  let sampleRate : SignalTime

  var periodLength : SignalTime { get { return sampleRate/frequency } }

  func value(time: SignalTime) -> SignalValue {
    let tau = Float(2 * M_PI)
    let tau_ft = tau * Float(frequency*time)/Float(sampleRate)
    let p = Float(phase)
    let v = Float(amplitude) * sinf(tau_ft + p)

    return SignalValue(v)
  }
}


let src1 = SineSource(frequency: 441, amplitude: 1, phase: 0, sampleRate: 44100)

let src2 = SineSource(frequency: 882, amplitude: 1, phase: 0, sampleRate: 44100)

let src3 = ConstantSource(2)

let m1 = MixerSource(inputs:[src1, src2, src3])

let ys = (0...m1.periodLength).map{m1.value($0)}

let p = m1.periodLength


