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
    case .infiniteLoadingReusable:
      navigateInfiniteLoadingReusable()
    case .sectionTabBar:
      navigateTabBarStore()
    case .sampleNavigation:
      break
    }
  }
  
  private func navigateUIKitView() {
  }
  
  private func navigateMixedView() {
  }
  
  private func navigateComposableView() {
  }
  
  private func navigateInfiniteLoading() {
  }
  
  private func navigateInfiniteLoadingReusable() {
  }
  
  private func navigateTabBarStore() {
  }
}
