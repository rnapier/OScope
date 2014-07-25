//
//  FFT.m
//  OScope
//
//  Created by Rob Napier on 7/17/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

#import "FFT.h"
@import Accelerate;

NSArray *SpectrumForValues(NSArray *samples) {
  int Log2N = log2f(samples.count);
  int N = 1u << Log2N;
  int Stride = 1;

  double *signal = (double*)calloc(1, N * Stride * sizeof *signal);
  double *fft = (double*)calloc(1, N * sizeof *fft);

  //Fill Input Array
  for (int i=0; i < N; i++) {
    signal[i] = [samples[i] doubleValue];
  }

  UInt32 inMaxFramesPerSlice = N;
  double  mFFTNormFactor = 1.0/(2*inMaxFramesPerSlice);
  UInt32 mFFTLength = inMaxFramesPerSlice/2;
  UInt32 mLog2N = Log2N; // (int)ceilf(log2f(inMaxFramesPerSlice));

  DSPDoubleSplitComplex mDspSplitComplex;
  mDspSplitComplex.realp = (double*) calloc(mFFTLength,sizeof(double));
  mDspSplitComplex.imagp = (double*) calloc(mFFTLength, sizeof(double));
  FFTSetupD mSpectrumAnalysis = vDSP_create_fftsetupD(mLog2N, kFFTRadix2);

  double *inAudioData = signal;
  double *outFFTData = fft;

  //Generate a split complex vector from the real data
  vDSP_ctozD((DSPDoubleComplex *)inAudioData, 2, &mDspSplitComplex, 1, mFFTLength);

  //Take the fft and scale appropriately
  vDSP_fft_zripD(mSpectrumAnalysis, &mDspSplitComplex, 1, mLog2N, kFFTDirection_Forward);

  vDSP_vsmulD(mDspSplitComplex.realp, 1, &mFFTNormFactor, mDspSplitComplex.realp, 1, mFFTLength);
  vDSP_vsmulD(mDspSplitComplex.imagp, 1, &mFFTNormFactor, mDspSplitComplex.imagp, 1, mFFTLength);

  //Zero out the nyquist value
  mDspSplitComplex.imagp[0] = 0.0;

  //Convert the fft data to dB
  vDSP_zvmagsD(&mDspSplitComplex, 1, outFFTData, 1, mFFTLength);

  // FIXME: Converting to dB actually makes the graph confusing.
  //In order to avoid taking log10 of zero, an adjusting factor is added in to make the minimum value equal -128dB
  //  vDSP_vsadd(outFFTData, 1, &kAdjust0DB, outFFTData, 1, mFFTLength);
  //  Float32 one = 1;
  //  vDSP_vdbcon(outFFTData, 1, &one, outFFTData, 1, mFFTLength, 0);

  vDSP_destroy_fftsetupD(mSpectrumAnalysis);
  free (mDspSplitComplex.realp);
  free (mDspSplitComplex.imagp);

  NSMutableArray *result = [NSMutableArray array];
  for (int i =0; i < N/2; i++) {
    [result addObject:@(fft[i] * fft[i])];
  }

  free(fft);
  free(signal);

  return result;
}
