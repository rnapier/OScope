//
//  ScopeViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import SignalKit
import KnobControl

class ScopeViewController: UIViewController {

  @IBOutlet weak var signalVisualizerView : SignalVisualizerView!
  @IBOutlet weak var yScaleKnob: KnobControl!
  @IBOutlet weak var yScaleAutoButton: HighlightButton!
  @IBOutlet weak var xScaleKnob: KnobControl!
  @IBOutlet weak var domainSwitch: UISwitch!

  var yScale: VisualizerScale  {
  get { return self.signalVisualizerView.yScale }
  set {
    self.signalVisualizerView.yScale = newValue
    self.updateYScaleControls(animated: true)
  }
  }

  var source : SignalSource? {
  get { return self.signalVisualizerView.source }
  set(newValue) {
    self.signalVisualizerView.source = newValue
    self.updateYScaleControls(animated:false)
  }
  }

  var domain : VisualizerDomain {
  get { return self.signalVisualizerView.domain }
  set { self.signalVisualizerView.domain = newValue }
  }

  override func viewDidLoad() {
    self.updateYScaleControls(animated: false)
  }

  func updateYScaleControls(#animated: Bool) {
    switch self.yScale {
    case .Absolute(_):
      self.yScaleAutoButton.value = false
      self.yScaleKnob.enabled = true
      self.yScaleKnob.tintColor = UIColor.blueColor()
    case .Automatic:
      self.yScaleAutoButton.value = true
      self.yScaleKnob.enabled = false
      self.yScaleKnob.tintColor = UIColor.grayColor().colorWithAlphaComponent(0.3)

      if let visualizer = signalVisualizerView.visualizer {
        self.yScaleKnob.setValue(CGFloat(visualizer.automaticYScale), animated: animated)
      }
      else {
        self.yScaleKnob.setValue(0, animated: animated)
      }
    }
  }
  @IBAction func yScaleChanged(sender: KnobControl) {
    self.yScale = .Absolute(Float(self.yScaleKnob.value))
  }

  @IBAction func performYScaleAutoButton(sender: HighlightButton) {
    if self.yScaleAutoButton.value {
      self.yScale = .Absolute(Float(self.yScaleKnob.value))
    } else {
      self.yScale = .Automatic
    }
    self.updateYScaleControls(animated:true)
  }

  @IBAction func performDomainSwitch(sender: AnyObject) {
    self.domain = self.domainSwitch.on ? .Frequency : .Time
  }

  @IBAction func xScaleChanged(sender: KnobControl) {
  }
}
