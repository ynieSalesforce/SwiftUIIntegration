//
//  NavigationHandler.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/4/24.
//

import Foundation
import UIKit

enum NavigationAction {
  case uikitView
  case mixedView
  case composableView
}

extension UIViewController {
  func handle(action: NavigationAction) {
    switch action {
    case .uikitView:
      navigateUIKitView()
    case .mixedView:
      navigateMixedView()
    case .composableView:
      navigateComposableView()
    }
  }
  
  private func navigateUIKitView() {
    
  }
  
  private func navigateMixedView() {
    
  }
  
  private func navigateComposableView() {
    
  }
}
