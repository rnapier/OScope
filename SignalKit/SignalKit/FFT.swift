//
//  FFT.swift
//  Signal
//
//  Created by Rob Napier on 7/24/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import Accelerate

func spectrumForValues(signal: [Double]) -> [Double] {
  let Log2N = Int(log2(Double(signal.count)))
  let N = 1 << Log2N

  var fft = [Double](count:N, repeatedValue:0.0)

  var mFFTNormFactor:Double = 1.0 / Double(2*N)
  let mFFTLength = N/2;

  let mSpectrumAnalysis = create_fftsetupD(vDSP_Length(Log2N), FFTRadix(kFFTRadix2))

  //Generate a split complex vector from the real data
  var realp = [Double](count:mFFTLength, repeatedValue:0.0)
  var imagp = [Double](count:mFFTLength, repeatedValue:0.0)

  var mDspSplitComplex = DSPDoubleSplitComplex(realp:&realp, imagp:&imagp)
  ctozD(ConstUnsafePointer(signal), 2, &mDspSplitComplex, 1, vDSP_Length(mFFTLength))

  //Take the fft and scale appropriately
  fft_zripD(mSpectrumAnalysis, &mDspSplitComplex, 1, vDSP_Length(Log2N), FFTDirection(kFFTDirection_Forward))

  vsmulD(mDspSplitComplex.realp, 1, &mFFTNormFactor, mDspSplitComplex.realp, 1, vDSP_Length(mFFTLength))
  vsmulD(mDspSplitComplex.imagp, 1, &mFFTNormFactor, mDspSplitComplex.imagp, 1, vDSP_Length(mFFTLength))

  //Zero out the nyquist value
  mDspSplitComplex.imagp[0] = 0.0;

  //Convert the fft data to dB
  vDSP_zvmagsD(&mDspSplitComplex, 1, &fft, 1, vDSP_Length(mFFTLength))

  // FIXME: Converting to dB actually makes the graph confusing.
  //In order to avoid taking log10 of zero, an adjusting factor is added in to make the minimum value equal -128dB
  //  vDSP_vsadd(outFFTData, 1, &kAdjust0DB, outFFTData, 1, mFFTLength);
  //  Float32 one = 1;
  //  vDSP_vdbcon(outFFTData, 1, &one, outFFTData, 1, mFFTLength, 0);
  destroy_fftsetupD(mSpectrumAnalysis)
  return fft
}
