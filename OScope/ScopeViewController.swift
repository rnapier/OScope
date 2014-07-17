//
//  ScopeViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ScopeViewController: UIViewController {

  @IBOutlet var signalVisualizerView : SignalVisualizerView
  @IBOutlet var yScaleKnob: KnobControl
  @IBOutlet var yScaleAutoButton: HighlightButton

  var yScale: VisualizerScale = .Automatic

  var source : SignalSource? {
  get {
    return signalVisualizerView.source
  }
  set(newValue) {
    signalVisualizerView.source = newValue
  }
  }

  override func viewDidLoad() {
    switch yScale {
    case .Automatic:
      yScaleAutoButton.value = true
      yScaleKnob.enabled = false
    case .Absolute(let scale):
      yScaleAutoButton.value = false
      yScaleKnob.enabled = true
    }
    signalVisualizerView.yScale = yScale
  }

  @IBAction func yScaleChanged(sender: KnobControl) {
  }

  @IBAction func performYScaleAutoButton(sender: HighlightButton) {
    if yScaleAutoButton.value {
      yScaleAutoButton.value = false
      yScaleKnob.enabled = true
      yScale = .Absolute(yScaleKnob.value)
    } else {
      yScaleAutoButton.value = true
      yScaleKnob.enabled = false
      yScale = .Automatic
    }
  }
}
