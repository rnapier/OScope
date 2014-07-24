//
//  OScopeTests.swift
//  OScopeTests
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import XCTest
import Signal

class OScopeTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

//  func testForAll() {
//    XCTAssertTrue(forAll([2,4,6], { $0%2 == 0 }), "All even")
//    XCTAssertFalse(forAll(1...4, { $0%2 == 0 }), "All not even")
//    XCTAssertTrue(forAll([], {$0%2 == 0}), "Is true if nothing is false")
//
//    let c = [1,1,1]
//    XCTAssertTrue(forAll(c) { $0 == c[c.startIndex] }, "allEqual by hand")
//  }
//
//  func testAllEqual() {
//    XCTAssertTrue(allEqual([1,1,1], 1), "All equal")
//    XCTAssertFalse(allEqual(1...4, 1), "All not equal")
//  }
//
//  func testLcm() {
//    XCTAssertEqual(lcm([1,2,3]), 6, "6")
//    XCTAssertEqual(lcm([5,10,15]), 30, "30")
//  }


  func testConstantSource() {
    let value:SignalValue = 3
    let src = ConstantSource(value: value)
    XCTAssertEqual(src.value(0.seconds), value)
    XCTAssertEqual(src.value(1.second), value)
    XCTAssertEqual(src.value(3.seconds), value)
  }

  func testSineSource() {
    let f = 441.hertz
    let a = SignalValue(1)
    let p = Radians(0)
    let r = 44100.hertz
    let accuracy = SignalValue(0.001)

    let period = 1.0/f

    let src = SineSource(frequency: f, amplitude: a, phase: p)

    XCTAssertEqual(src.value(0.second), 0)
    XCTAssertEqualWithAccuracy(src.value(0.25 * period), SignalValue(1.0), accuracy)
    XCTAssertEqualWithAccuracy(src.value(0.5 * period), 0.0, accuracy)
    XCTAssertEqualWithAccuracy(src.value(0.75 * period), -1.0, accuracy)
  }

  func testFlatten() {
    let a = [[1], [2], [3]]
    XCTAssert(flatten(a) == [1,2,3])
  }

  func testSignalSourceLocation() {
    let s1 = SineSource(frequency: 1.hertz, amplitude: 1, phase: M_PI)
    let s2 = s1

    let s3 = s1
    let s4 = s1
    let m2 = MixerSource(inputs: [s3, s4])
    let m1 = MixerSource(inputs: [s1, s2, m2])

    let loc = NetworkNode(source:m1)
    XCTAssertEqual(loc.height, 4)
  }

  func testNetworkViewModel() {
    let s1 = SineSource(frequency: 1.hertz, amplitude: 1, phase: M_PI)
    let s2 = s1

    let s3 = s1
    let s4 = s1
    let m2 = MixerSource(inputs: [s3, s4])
    let m1 = MixerSource(inputs: [s1, s2, m2])

    let network = NetworkViewModel(rootSource: m1)
//    println(network.layout(CGRectMake(0, 0, 100, 100)))
    // FIXME: Perform test
  }

  func testSampleTimes() {
    let sampleRate = 44100.hertz
    let times = SignalSampleTimes(start:0.second, end:1.millisecond, sampleRate:sampleRate)
    XCTAssertEqual(countElements(times), 44)
  }

  func testTimeDomain() {
    let sampleRate = 44100.hertz
    let source11 = SineSource(frequency: 440.hertz, amplitude: 1, phase: 0)
    let source12 = SineSource(frequency: 800.hertz, amplitude: 1, phase: 0)
    let source13 = SineSource(frequency: 1000.hertz, amplitude: 1, phase: M_PI)
    let mixer1 = MixerSource(inputs: [source11, source12, source13])

    let source21 = SineSource(frequency: 1200.hertz, amplitude: 1, phase: 0)
    let source22 = SineSource(frequency: 200.hertz, amplitude: 1, phase: 0)
    let mixer2 = MixerSource(inputs: [source21, source22])

    let source31 = SineSource(frequency: 11100.hertz, amplitude: 1, phase: 0)
    let mixer3 = MixerSource(inputs: [ mixer1, mixer2, source31])

    let output = mixer3

    // Verify that two calls give the same result
    let times = SignalSampleTimes(start:0.second, end:1.millisecond, sampleRate:sampleRate)
    let values  = valuesForSource(source11, sampleTimes: SignalSampleTimes(start:0.second, end:1.millisecond, sampleRate:sampleRate), domain: .Time)
    let values2 = valuesForSource(source11, sampleTimes: SignalSampleTimes(start:0.second, end:1.millisecond, sampleRate:sampleRate), domain: .Time)
    XCTAssert(values == values2)
  }
}
