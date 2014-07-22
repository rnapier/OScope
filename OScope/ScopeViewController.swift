//
//  ScopeViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ScopeViewController: UIViewController {

  @IBOutlet var signalVisualizerView : SignalVisualizerView!
  @IBOutlet var yScaleKnob: KnobControl!
  @IBOutlet var yScaleAutoButton: HighlightButton!
  @IBOutlet var domainSwitch: UISwitch!

  var yScale: VisualizerScale = .Automatic {
  didSet {
    signalVisualizerView.yScale = yScale
    updateYScaleControls(animated: true)
  }
  }

  var source : SignalSource? {
  get {
    return signalVisualizerView.source
  }
  set(newValue) {
    signalVisualizerView.source = newValue
    updateYScaleControls(animated:false)
  }
  }

  var domain : VisualizerDomain = .Time {
  didSet {
    signalVisualizerView.domain = domain
  }
  }

  override func viewDidLoad() {
    signalVisualizerView.yScale = yScale
    updateYScaleControls(animated: false)
  }

  func updateYScaleControls(#animated: Bool) {
    switch yScale {
    case .Absolute(_):
      yScaleAutoButton.value = false
      yScaleKnob.enabled = true
      yScaleKnob.tintColor = UIColor.blueColor()
    case .Automatic:
      yScaleAutoButton.value = true
      yScaleKnob.enabled = false
      yScaleKnob.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.3)

      if let visualizer = signalVisualizerView.visualizer {
        yScaleKnob.setValue(CGFloat(visualizer.automaticYScale), animated: animated)
      }
      else {
        yScaleKnob.setValue(0, animated: animated)
      }
    }
  }
  @IBAction func yScaleChanged(sender: KnobControl) {
    yScale = .Absolute(Float(yScaleKnob.value))
  }

  @IBAction func performYScaleAutoButton(sender: HighlightButton) {
    if yScaleAutoButton.value {
      yScale = .Absolute(Float(yScaleKnob.value))
    } else {
      yScale = .Automatic
    }
    updateYScaleControls(animated:true)
  }

  @IBAction func performDomainSwitch(sender: AnyObject) {
    domain = domainSwitch.on ? .Frequency : .Time
  }
}
