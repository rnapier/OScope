//
//  FFT.swift
//  Signal
//
//  Created by Rob Napier on 7/24/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Accelerate

internal func spectrumForValues(signal: [Double]) -> [Double] {
  // Find the largest power of two in our samples
  let log2N = vDSP_Length(log2(Double(signal.count)))
  let n = 1 << log2N
  let fftLength = n / 2

  // This is expensive; factor it out if you need to call this function a lot
  let fftsetup = vDSP_create_fftsetupD(log2N, FFTRadix(kFFTRadix2))

  var fft = [Double](count:Int(n), repeatedValue:0.0)

  // Generate a split complex vector from the real data
  var realp = [Double](count:Int(fftLength), repeatedValue:0.0)
  var imagp = realp

  withExtendedLifetimes(realp, imagp) {
    var splitComplex = DSPDoubleSplitComplex(realp:&realp, imagp:&imagp)
    vDSP_ctozD(UnsafePointer(signal), 2, &splitComplex, 1, fftLength)

    // Take the fft
    vDSP_fft_zripD(fftsetup, &splitComplex, 1, log2N, FFTDirection(kFFTDirection_Forward))

    // Normalize
    var normFactor = 1.0 / Double(2 * n)
    vDSP_vsmulD(splitComplex.realp, 1, &normFactor, splitComplex.realp, 1, fftLength)
    vDSP_vsmulD(splitComplex.imagp, 1, &normFactor, splitComplex.imagp, 1, fftLength)

    // Zero out Nyquist
    splitComplex.imagp[0] = 0.0

    // Convert complex FFT to magnitude
    vDSP_zvmagsD(&splitComplex, 1, &fft, 1, fftLength)
  }

  // Cleanup
  vDSP_destroy_fftsetupD(fftsetup)
  return fft
}

// To get rid of the `() -> () in` casting
func withExtendedLifetime<T>(x: T, f: () -> ()) {
  return Swift.withExtendedLifetime(x, f)
}

// In the spirit of withUnsafePointers
func withExtendedLifetimes<A0, A1>(arg0: A0, arg1: A1, f: () -> ()) {
  return withExtendedLifetime(arg0) { withExtendedLifetime(arg1, f) }
}