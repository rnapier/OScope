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
  println("lcm start", xs)
  assert(forAll(xs, { $0 > 0 }), "All values must be positive")

  var accums = xs

  while !allEqual(accums, accums[0]) {
    if let m = minElementAt(accums) {
      accums[m] += xs[m]
    } else {
      assert(false, "BUG: every non-empty collection should have a minimum")
    }
    println(accums)
  }
  let result = accums[0]
  println("lcm stop", result)
  return accums[0]
}
