//
//  Future.swift
//  swiftz
//
//  Created by Maxwell Swadling on 4/06/2014.
//  Copyright (c) 2014 Maxwell Swadling. All rights reserved.
//

import Dispatch

class Future<A> {
  var value: A?

  // The resultQueue is used to read the result. It begins suspended
  // and is resumed once a result exists.
  // FIXME: Would like to add a uniqueid to the label
  let resultQueue = dispatch_queue_create("swift.future", DISPATCH_QUEUE_CONCURRENT)

  let execCtx: ExecutionContext // for map
  init(exec: ExecutionContext) {
    dispatch_suspend(self.resultQueue)
    execCtx = exec
  }
  init(exec: ExecutionContext, _ a: () -> A) {
    dispatch_suspend(self.resultQueue)
    execCtx = exec
    exec.submit(self, work: a)
  }

  func sig(x: A) {
    assert(self.value == nil, "Future cannot complete more than once")
    self.value = x
    dispatch_resume(self.resultQueue)
  }

  func result() -> A {
    var result : A? = nil
    dispatch_sync(resultQueue, {
      result = self.value!
      })
    return result!
  }

  func map<B>(f: A -> B) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()) })
  }

  func flatMap<B>(f: A -> Future<B>) -> Future<B> {
    return Future<B>(exec: execCtx, { f(self.result()).result() })
  }
}