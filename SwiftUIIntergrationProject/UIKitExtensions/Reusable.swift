//
//  Reusable.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import UIKit

public protocol Reusable: AnyObject {
    /// The reuse identifier to use when registering and later dequeuing a reusable cell
  static var reuseIdentifier: String { get }
}

  // MARK: - Default implementation

public extension Reusable {
    /// By default, use the name of the class as String for its reuseIdentifier
  static var reuseIdentifier: String {
    String(describing: self)
  }
}
