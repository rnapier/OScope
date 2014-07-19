//
//  FFT.m
//  OScope
//
//  Created by Rob Napier on 7/17/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

#import "FFT.h"
#import <Accelerate/Accelerate.h>
#include "CABitOperations.h"


class FFTHelper
{
public:
  FFTHelper( UInt32 inMaxFramesPerSlice );
  ~FFTHelper();

  void ComputeFFT ( Float32* inAudioData, Float32* outFFTData );

private:
  FFTSetup            mSpectrumAnalysis;
  DSPSplitComplex     mDspSplitComplex;
  Float32             mFFTNormFactor;
  UInt32              mFFTLength;
  UInt32              mLog2N;
};




//const Float32 kAdjust0DB = 1.5849e-13;


FFTHelper::FFTHelper ( UInt32 inMaxFramesPerSlice )
: mSpectrumAnalysis(NULL),
mFFTNormFactor(1.0/(2*inMaxFramesPerSlice)),
mFFTLength(inMaxFramesPerSlice/2),
mLog2N(Log2Ceil(inMaxFramesPerSlice))
{
  mDspSplitComplex.realp = (Float32*) calloc(mFFTLength,sizeof(Float32));
  mDspSplitComplex.imagp = (Float32*) calloc(mFFTLength, sizeof(Float32));
  mSpectrumAnalysis = vDSP_create_fftsetup(mLog2N, kFFTRadix2);
}


FFTHelper::~FFTHelper()
{
  vDSP_destroy_fftsetup(mSpectrumAnalysis);
  free (mDspSplitComplex.realp);
  free (mDspSplitComplex.imagp);
}


void FFTHelper::ComputeFFT(Float32* inAudioData, Float32* outFFTData)
{
  if (inAudioData == NULL || outFFTData == NULL) return;

  //Generate a split complex vector from the real data
  vDSP_ctoz((COMPLEX *)inAudioData, 2, &mDspSplitComplex, 1, mFFTLength);

  //Take the fft and scale appropriately
  vDSP_fft_zrip(mSpectrumAnalysis, &mDspSplitComplex, 1, mLog2N, kFFTDirection_Forward);
  vDSP_vsmul(mDspSplitComplex.realp, 1, &mFFTNormFactor, mDspSplitComplex.realp, 1, mFFTLength);
  vDSP_vsmul(mDspSplitComplex.imagp, 1, &mFFTNormFactor, mDspSplitComplex.imagp, 1, mFFTLength);

  //Zero out the nyquist value
  mDspSplitComplex.imagp[0] = 0.0;

  //Convert the fft data to dB
  vDSP_zvmags(&mDspSplitComplex, 1, outFFTData, 1, mFFTLength);

  // FIXME: Converting to dB actually makes the graph confusing.
  //In order to avoid taking log10 of zero, an adjusting factor is added in to make the minimum value equal -128dB
//  vDSP_vsadd(outFFTData, 1, &kAdjust0DB, outFFTData, 1, mFFTLength);
//  Float32 one = 1;
//  vDSP_vdbcon(outFFTData, 1, &one, outFFTData, 1, mFFTLength, 0);
}

NSArray *SpectrumForValues(NSArray *samples) {
  int Log2N = log2f(samples.count);
  int N = 1u << Log2N;
  int Stride = 1;

  Float32 *signal = (float*)calloc(1, N * Stride * sizeof *signal);
  Float32 *fft = (float*)calloc(1, N * sizeof *fft);

    //Fill Input Array
    for (int i=0; i < N; i++) {
      signal[i] = [samples[i] floatValue];
    }

  FFTHelper fftHelper((UInt32)N);
  fftHelper.ComputeFFT(signal, fft);

  NSMutableArray *result = [NSMutableArray array];
  for (int i =0; i < N/2; i++) {
    [result addObject:@(fft[i] * fft[i])];
  }

  free(fft);
  free(signal);

  return result;
}
