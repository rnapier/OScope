//
//  OScopeTests.swift
//  OScopeTests
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import XCTest
import SignalKit

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
    let value = 3 * Volt
    let src = ConstantSource(value: value)
    XCTAssertEqual(src.output(0 * Second), value)
    XCTAssertEqual(src.output(1 * Second), value)
    XCTAssertEqual(src.output(3 * Second), value)
  }

  func testSineSource() {
    let f = 441 * Hertz
    let a = 1 * Volt
    let p = Radians(0)
    let r = 44100 * Hertz
    let accuracy = 1e-12

    let period = 1.0/f

    let src = SineSource(frequency: f, amplitude: a, phase: p)

    XCTAssertEqualWithAccuracy(src.output(0 * Second).volts, 0, accuracy)
    XCTAssertEqualWithAccuracy(src.output(0.25 * period).volts, 1, accuracy)
    XCTAssertEqualWithAccuracy(src.output(0.5 * period).volts, 0, accuracy)
    XCTAssertEqualWithAccuracy(src.output(0.75 * period).volts, -1, accuracy)
  }

//  func testFlatten() {
//    let a = [[1], [2], [3]]
//    XCTAssert(flatten(a) == [1,2,3])
//  }

  func testSignalSourceLocation() {
    let s1 = SineSource(frequency: 1 * Hertz, amplitude: 1 * Volt, phase: M_PI)
    let s2 = s1

    let s3 = s1
    let s4 = s1
    let m2 = MixerSource(inputs: [s3, s4])
    let m1 = MixerSource(inputs: [s1, s2, m2])

    let loc = NetworkNode(source:m1)
    XCTAssertEqual(loc.height, 4)
  }

//  func testNetworkViewModel() {
//    let s1 = SineSource(frequency: 1 * Hertz, amplitude: 1 * Volt, phase: M_PI)
//    let s2 = s1
//
//    let s3 = s1
//    let s4 = s1
//    let m2 = MixerSource(inputs: [s3, s4])
//    let m1 = MixerSource(inputs: [s1, s2, m2])
//
//    let network = NetworkViewModel(rootSource: m1)
////    println(network.layout(CGRectMake(0, 0, 100, 100)))
//    // FIXME: Perform test
//  }

//  func testSampleTimes() {
////    let sampleRate = 44100 * Hertz
//    let times = SignalSampleTimes(start:0 * Second, end:1 * Millisecond, samples:44)
//    XCTAssertEqual(count(times), 44)
//  }

//  func testTimeDomain() {
//    let sampleRate = 44100 * Hertz
//    let source11 = SineSource(frequency: 440 * Hertz, amplitude: 1 * Volt, phase: 0)
//    let source12 = SineSource(frequency: 800 * Hertz, amplitude: 1 * Volt, phase: 0)
//    let source13 = SineSource(frequency: 1000 * Hertz, amplitude: 1 * Volt, phase: M_PI)
//    let mixer1 = MixerSource(inputs: [source11, source12, source13])
//
//    let source21 = SineSource(frequency: 1200 * Hertz, amplitude: 1 * Volt, phase: 0)
//    let source22 = SineSource(frequency: 200 * Hertz, amplitude: 1 * Volt, phase: 0)
//    let mixer2 = MixerSource(inputs: [source21, source22])
//
//    let source31 = SineSource(frequency: 11100 * Hertz, amplitude: 1 * Volt, phase: 0)
//    let mixer3 = MixerSource(inputs: [ mixer1, mixer2, source31])
//
//    let output = mixer3
//
//    // Verify that two calls give the same result
//    let times = SignalSampleTimes(start:0 * Second, end:1 * Millisecond, samples: 100)
//    let values = SignalVisualizer(source: source11, domain: .Time, frame: CGRectMake(0,0,100,100), samplesRate: 44100 * Hertz, yScale: .Automatic).values
//    let values2 = SignalVisualizer(source: source11, domain: .Time, frame: CGRectMake(0,0,100,100), sampleRate: 44100 * Hertz, yScale: .Automatic).values
//    XCTAssert(values == values2)
//  }
}
