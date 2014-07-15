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

func flatten<T>(xs: [[T]]) -> [T] {
  return [T]().join(xs)
}

extension Array {
  func bind<U>(f:(T -> [U])) -> [U] {
    return flatten(self.map(f))
  }
}

operator infix >>= {
  associativity left
}

func >>=<T,U>(xs: [T], f:(T -> [U])) -> [U] {
  return flatten(xs.map(f))
}

func +<T>(lhs: [T], rhs: T) -> [T] {
  return lhs + [rhs]
}
