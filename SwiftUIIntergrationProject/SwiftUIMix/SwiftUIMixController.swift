//
//  SwiftUIMixController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import UIKit
import SwiftUI

class SwiftUIMixController: BaseViewController {
  override func configureUI() {
    let viewModel = SwiftUIMixViewModel()
    let swiftUIView = SwiftUIMixView(viewModel: viewModel)
    let hosting = UIHostingController(rootView: swiftUIView)
    addChild(hosting)
    view.addSubview(hosting.view)
    hosting.view.snp.updateConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    loadingView.removeFromSuperview()
  }
}
