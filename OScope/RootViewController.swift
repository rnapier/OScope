//
//  ViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

  // FIXME: Should be able to connect to the container view in IB
  var scopeViewController : ScopeViewController?
  var networkViewController : NetworkViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    for vc in childViewControllers as [UIViewController] {
      switch vc {
      case let vc as ScopeViewController:
        scopeViewController = vc
      case let vc as NetworkViewController:
        networkViewController = vc
      default:
        break
      }
    }

    let sampleRate = SignalTime(44100)
    let source11 = SineSource(frequency: 440, amplitude: 1, phase: 0, sampleRate: sampleRate)
    let source12 = SineSource(frequency: 800, amplitude: 1, phase: 0, sampleRate: sampleRate)
    let source13 = SineSource(frequency: 1000, amplitude: 1, phase: 500, sampleRate: sampleRate)
    let mixer1 = MixerSource(inputs: [source11, source12, source13])

    let source21 = SineSource(frequency: 1200, amplitude: 1, phase: 0, sampleRate: sampleRate)
    let source22 = SineSource(frequency: 200, amplitude: 1, phase: 0, sampleRate: sampleRate)
    let mixer2 = MixerSource(inputs: [source21, source22])

    let source31 = SineSource(frequency: 11100, amplitude: 1, phase: 0, sampleRate: sampleRate)
    let mixer3 = MixerSource(inputs: [ mixer1, mixer2, source31])

    let output = mixer3

    scopeViewController.map{ $0.source = output }
    networkViewController.map{ $0.rootSource = output }
  }
}

