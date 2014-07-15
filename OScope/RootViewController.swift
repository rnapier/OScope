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

    let source = SineSource(frequency: 441, amplitude: 1, phase: 0, sampleRate: 44000)
    if let svc = scopeViewController {
      svc.source = source
    }
  }
}

