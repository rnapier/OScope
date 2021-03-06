//
//  Lambda.swift
//  OScope
//
//  Created by Rob Napier on 7/14/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//


//extension Array {
//  func flatten<A where T == Array<A>>() -> [A] {
//    var result = [A]()
//    for x in self {
//      if let x = x as? [A] {
//        result.extend(x)
//      }
//    }
//    return result
//  }
//}

//func flatten<T>(xs: [[T]]) -> [T] {
//  return [T]().join(xs)
//}
//
func flatten<T>(root: T, children:((T)->[T])) -> [T] {
  var result = [root]
  for node in children(root) {
    result.extend(flatten(node, children))
  }
  return result
}
//
//extension Array {
//  func flatMap<U>(f:(T -> [U])) -> [U] {
//    return flatten(self.map(f))
//  }
//}


//func flatMap<P>(f:T -> P?) -> P? {
//  switch self {
//  case .Success(let value):
//    return .Success(f(value))
//  case .Error(let msg):
//    return .Error(msg)
//  }
//}

//infix operator  >>= {
//associativity left
//}
//
//func >>=<T,U>(xs: [T], f:(T -> [U])) -> [U] {
//  return flatten(xs.map(f))
//}
//
//func +<T>(lhs: [T], rhs: T) -> [T] {
//  return lhs + [rhs]
//}
//

//func combinations
//  <First:SequenceType, Second:Collection>
//  (first: First, second: Second) -> SequenceOf<(First.GeneratorType.Element, Second.GeneratorType.Element)> {
//
//    var firstGeneator = first.generate()
//    var nextElement = firstGeneator.next()
//    var secondIndex = second.startIndex
//
//    return SequenceOf(GeneratorOf( {
//      if let firstElement = nextElement {
//        let secondElement = second[secondIndex]
//        secondIndex++
//        if secondIndex == second.endIndex {
//          nextElement = firstGeneator.next()
//          secondIndex = second.startIndex
//        }
//        return (firstElement, secondElement)
//      } else {
//        return nil
//      }
//      }
//      ))
//}
