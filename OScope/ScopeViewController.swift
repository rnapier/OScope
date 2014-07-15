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

  var source : SignalSource? {
  get {
    return signalVisualizerView.source
  }
  set(newValue) {
      signalVisualizerView.source = newValue
    }
  }
}
