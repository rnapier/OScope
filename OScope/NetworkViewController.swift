//
//  SignalGraphViewController.swift
//  OScope
//
//  Created by Rob Napier on 7/13/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import Signal

class NetworkViewController: UIViewController {
  var viewModel : NetworkViewModel?

  var rootSource : Signal.Source? {
  get { return self.viewModel?.rootNode.source }
  set(newValue) {
    self.viewModel = newValue.map {NetworkViewModel(rootSource: $0)}
    if let networkView = view as? NetworkView {
      networkView.viewModel = self.viewModel
    }
  }
  }



}
