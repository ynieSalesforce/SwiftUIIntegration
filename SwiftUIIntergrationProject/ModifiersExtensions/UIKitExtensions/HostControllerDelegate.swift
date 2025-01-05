//
//  HostControllerDelegate.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/16/24.
//

import Foundation
import UIKit

protocol HostControllerDelegate {
  func hideNavigation(hide: Bool)
}

extension HostControllerDelegate where Self: UIViewController {
  func hideNavigation(hide: Bool){
    navigationController?.setNavigationBarHidden(hide, animated: false)
  }
}
