//
//  NavigationHandler.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/4/24.
//

import Foundation
import UIKit

extension UIViewController {
  func handle(action: DemoType) {
    switch action {
    case .uiKit:
      navigateUIKitView()
    case .mix:
      navigateMixedView()
    case .swiftUI:
      navigateComposableView()
    case .infiniteLoading:
      navigateInfiniteLoading()
    }
  }
  
  private func navigateUIKitView() {
    let controller = UIKitReactiveController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  private func navigateMixedView() {
    let controller = SwiftUIMixController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  private func navigateComposableView() {
    let controller = WeatherComposableController()
    navigationController?.pushViewController(controller, animated: true)
  }
  
  private func navigateInfiniteLoading() {
    let controller = InfiniteLoadingController()
    navigationController?.pushViewController(controller, animated: true)
  }
}
