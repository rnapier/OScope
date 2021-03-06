//
//  ViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/10/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import SignalKit

class RootViewController: UIViewController {

  // FIXME: Should be able to connect to the container view in IB
  var scopeViewController : ScopeViewController?
  var networkViewController : NetworkViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    for vc in childViewControllers as! [UIViewController] { // FIXME: Can we do better
      switch vc {
      case let vc as ScopeViewController:
        self.scopeViewController = vc
      case let vc as NetworkViewController:
        self.networkViewController = vc
      default:
        break
      }
    }

    let sampleRate = 44100*Hertz
    let source11 = SineSource(frequency: 440*Hertz, amplitude: 1*Volt, phase: 0)
    let source12 = SineSource(frequency: 800*Hertz, amplitude: 1*Volt, phase: 0)
    let source13 = SineSource(frequency: 1000*Hertz, amplitude: 1*Volt, phase: M_PI_2)
    let mixer1 = MixerSource(inputs: [source11, source12, source13])

    let source21 = SineSource(frequency: 1200*Hertz, amplitude: 1*Volt, phase: 0)
    let source22 = SineSource(frequency: 200*Hertz, amplitude: 1*Volt, phase: 0)
    let mixer2 = MixerSource(inputs: [source21, source22])

    let source31 = SineSource(frequency: 8000*Hertz, amplitude: 1*Volt, phase: 0)
    let mixer3 = MixerSource(inputs: [ mixer1, mixer2, source31])

    let output = mixer3

    self.scopeViewController.map{ $0.source = output }
    self.networkViewController.map{ $0.rootSource = output }
  }
}

