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
  let fftsetup = create_fftsetupD(log2N, FFTRadix(kFFTRadix2))

  // Generate a split complex vector from the real data
  var realp = [Double](count:Int(fftLength), repeatedValue:0.0)
  var imagp = realp
  var splitComplex = DSPDoubleSplitComplex(realp:&realp, imagp:&imagp)
  ctozD(ConstUnsafePointer(signal), 2, &splitComplex, 1, fftLength)

  // Take the fft
  fft_zripD(fftsetup, &splitComplex, 1, log2N, FFTDirection(kFFTDirection_Forward))

  // Normalize
  var normFactor = 1.0 / Double(2 * n)
  vsmulD(splitComplex.realp, 1, &normFactor, splitComplex.realp, 1, fftLength)
  vsmulD(splitComplex.imagp, 1, &normFactor, splitComplex.imagp, 1, fftLength)

  // Zero out Nyquist
  splitComplex.imagp[0] = 0.0

  // Convert complex FFT to magnitude
  var fft = [Double](count:Int(n), repeatedValue:0.0)
  vDSP_zvmagsD(&splitComplex, 1, &fft, 1, fftLength)

  // Cleanup
  destroy_fftsetupD(fftsetup)
  return fft
}
