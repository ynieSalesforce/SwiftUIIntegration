//
//  WeatherComposableController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import UIKit
import SwiftUI
import ComposableArchitecture

class WeatherComposableController: BaseViewController {
  override func configureUI() {
    let store: StoreOf<WeatherStore> = .init(initialState: .init()) {
      WeatherStore()
    }
    let swiftUIView = ComposableView(store: store)
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
