//
//  SignalOutputGrapher.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

/*
A Visualizer creates visualization paths (UIBezierPath) for a
Signal within a frame (CGRect) in the time or frequency domains.
*/

import UIKit

public enum VisualizerScale {
  case Absolute(Float)
  case Automatic
}

public class Visualizer {
  public let waveform: Waveform
  let frame: CGRect
  let yScale: VisualizerScale

  public lazy var path: UIBezierPath = {
    let path = self.waveform.path.copy() as! UIBezierPath   // FIXME: Can I do better?
    let transform = pathTransform(frame:self.frame, yScale:self.yScale, values:self.waveform.values)
    path.applyTransform(transform)
    return path
  }()

  public var automaticYScale : CGFloat { return calculateAutomaticYScale(values:self.waveform.values) }

  public func withYScale(newYScale:VisualizerScale) -> Visualizer {
    return Visualizer(
      waveform: self.waveform,
      frame: self.frame,
      yScale: newYScale
    )
  }

  public init(waveform: Waveform, frame: CGRect, yScale: VisualizerScale) {
    self.waveform = waveform
    self.frame = frame
    self.yScale = yScale
  }
}

private func calculateAutomaticYScale(#values:[CGFloat]) -> CGFloat {
  return 1/values.map(abs).reduce(CGFloat(DBL_EPSILON), combine: max)
}

private func pathTransform(#frame: CGRect, #yScale:VisualizerScale, #values:[CGFloat]) -> CGAffineTransform {
  let height = CGRectGetHeight(frame)
  let yZero  = CGRectGetMidY(frame)
  let baseScale = -height/2
  let yScaleValue: CGFloat = baseScale * {
    switch yScale {
    case .Absolute(let value): return CGFloat(value)
    case .Automatic: return calculateAutomaticYScale(values:values)
    }
    }()

  let transform = CGAffineTransformScale(
    CGAffineTransformMakeTranslation(CGRectGetMinX(frame), yZero),
    1.0, CGFloat(yScaleValue))

  return transform
}
