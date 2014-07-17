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

  var yScale: VisualizerScale = .Automatic {
  didSet {
    signalVisualizerView.yScale = yScale
  }
  }

  var source : SignalSource? {
  get {
    return signalVisualizerView.source
  }
  set(newValue) {
    signalVisualizerView.source = newValue
  }
  }

  override func viewDidLoad() {
    updateYScaleControls()
    signalVisualizerView.yScale = yScale
  }

  func updateYScaleControls() {
    switch yScale {
    case .Absolute(_):
      yScaleAutoButton.value = false
      yScaleKnob.enabled = true
      yScaleKnob.tintColor = UIColor.blueColor()
    case .Automatic:
      yScaleAutoButton.value = true
      yScaleKnob.enabled = false
      yScaleKnob.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
    }
  }
  @IBAction func yScaleChanged(sender: KnobControl) {
    yScale = .Absolute(yScaleKnob.value)
  }

  @IBAction func performYScaleAutoButton(sender: HighlightButton) {
    if yScaleAutoButton.value {
      yScale = .Absolute(yScaleKnob.value)
    } else {
      yScale = .Automatic
    }
    updateYScaleControls()
  }
}
