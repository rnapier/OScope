//
//  SignalGraph.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

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
  var inputs:[SignalSource] { get }
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
  let value : SignalValue

  // FIXME: Why is this init required?
  init (_ value: SignalValue) {
    self.value = value
  }

  var periodLength : SignalTime { get { return SignalTime(1) } }
  let inputs = [SignalSource]()

  func value(time: SignalTime) -> SignalValue {
    return value
  }
}

struct SineSource : SignalSource {
  let frequency  : SignalTime
  let amplitude  : SignalValue
  let phase      : SignalTime
  let sampleRate : SignalTime

  // FIXME: Why is this init required?
  init(frequency: SignalTime, amplitude:SignalValue, phase:SignalTime, sampleRate:SignalTime) {
    self.frequency = frequency
    self.amplitude = amplitude
    self.phase = phase
    self.sampleRate = sampleRate
  }

  let inputs = [SignalSource]()
  var periodLength : SignalTime { get { return sampleRate/frequency } }

  func value(time: SignalTime) -> SignalValue {
    let tau = Float(2 * M_PI)
    let tau_ft = tau * Float(frequency*time)/Float(sampleRate)
    let p = Float(phase)
    let v = Float(amplitude) * sinf(tau_ft + p)

    return SignalValue(v)
  }
}


struct SignalSourceLocation {
  let signalSource: SignalSource
  let offset: Int
  let height: Int
  let inputs: [SignalSourceLocation]
}

func signalSourceLocation(root: SignalSource, offset:Int) -> SignalSourceLocation {
  var children = [SignalSourceLocation]()
  var height = 0
  for (index, input) in enumerate(root.inputs) {
    let child = signalSourceLocation(input, offset + index)
    height += child.height
    children.append(child)
  }

  return SignalSourceLocation(signalSource: root, offset: offset, height: max(height, 1), inputs: children)
}

let s1 = SineSource(frequency: 1, amplitude: 1, phase: 1, sampleRate:1)
let s2 = s1
let s3 = s1
let s4 = s1
let m1 = MixerSource(inputs: [s1, s2, s3, s4])

let loc = signalSourceLocation(m1, 0)
loc.inputs[0]


