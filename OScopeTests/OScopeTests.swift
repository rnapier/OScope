//
//  OScopeTests.swift
//  OScopeTests
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import XCTest

class OScopeTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testForAll() {
    XCTAssertTrue(forAll([2,4,6], { $0%2 == 0 }), "All even")
    XCTAssertFalse(forAll(1...4, { $0%2 == 0 }), "All not even")
    XCTAssertTrue(forAll([], {$0%2 == 0}), "Is true if nothing is false")

    let c = [1,1,1]
    XCTAssertTrue(forAll(c) { $0 == c[c.startIndex] }, "allEqual by hand")
  }

  func testAllEqual() {
    XCTAssertTrue(allEqual([1,1,1], 1), "All equal")
    XCTAssertFalse(allEqual(1...4, 1), "All not equal")
  }

  func testLcm() {
    XCTAssertEqual(lcm([1,2,3]), 6, "6")
    XCTAssertEqual(lcm([5,10,15]), 30, "30")
  }


  func testConstantSource() {
    let value:SignalValue = 3
    let src = ConstantSource(value)
    XCTAssertEqual(src.periodLength, 1)
    XCTAssertEqual(src.value(0), value)
    XCTAssertEqual(src.value(1), value)
    XCTAssertEqual(src.value(3), value)
  }

  func testSineSource() {
    let f = SignalTime(441)
    let a = SignalValue(1)
    let p = SignalTime(0)
    let r = SignalTime(44100)
    let accuracy = SignalValue(0.001)

    let src = SineSource(frequency: f, amplitude: a, phase: p, sampleRate:r)

    XCTAssertEqual(src.periodLength, 100.0)
    XCTAssertEqual(src.value(0), 0)
    XCTAssertEqualWithAccuracy(src.value(r/4), 1, accuracy)
    XCTAssertEqualWithAccuracy(src.value(r/2), 0, accuracy)
    XCTAssertEqualWithAccuracy(src.value(3*r/4), -1, accuracy)
  }

  func testFlatten() {
    let a = [[1], [2], [3]]
    XCTAssertEqualObjects(flatten(a), [1,2,3])
  }

  func testSignalSourceLocation() {
    let s1 = SineSource(frequency: 1, amplitude: 1, phase: 1, sampleRate:1)
    let s2 = s1

    let s3 = s1
    let s4 = s1
    let m2 = MixerSource(inputs: [s3, s4])
    let m1 = MixerSource(inputs: [s1, s2, m2])

    let loc = NetworkNode(source:m1)
    XCTAssertEqual(loc.height, 4)
  }

  func testNetworkViewModel() {
    let s1 = SineSource(frequency: 1, amplitude: 1, phase: 1, sampleRate:1)
    let s2 = s1

    let s3 = s1
    let s4 = s1
    let m2 = MixerSource(inputs: [s3, s4])
    let m1 = MixerSource(inputs: [s1, s2, m2])

    let network = NetworkViewModel(rootSource: m1)
    println(network.layout(CGRectMake(0, 0, 100, 100)))
    // FIXME: Perform test

  }

//  func testArrayFlatten() {
//    let a = [[1], [2], [3]]
//    let flatA : [Int] = a.flatten()
//    XCTAssertEqualObjects(flatA, [1,2,3])
//  }
//  func testInputPaths() {
//    let s1 = SineSource(frequency: 1, amplitude: 1, phase: 1, sampleRate: 1)
//    let s2 = SineSource(frequency: 2, amplitude: 2, phase: 2, sampleRate: 1)
//    let m = MixerSource(inputs: [s1, s2])
//    let paths = inputPaths(m)
//    println(paths)
//    let path1 : SignalPath = [s1,m]
//    let path2 : SignalPath = [s2,m]
//    let expectedPaths : [SignalPath] = [path1, path2]
//    println(expectedPaths)
//    let result = (paths == expectedPaths)
//    XCTAssertTrue(result)
//  }
}
