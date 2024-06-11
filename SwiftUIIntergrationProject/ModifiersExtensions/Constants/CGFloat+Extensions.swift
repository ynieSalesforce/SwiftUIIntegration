//
//  CGFloat+Extensions.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/4/24.
//

import Foundation

extension CGFloat {
    /// CGFloat = 0
  static let tdsNone: CGFloat = 0
    /// CGFloat = 1
  static let tdsXxxxSmall: CGFloat = 2
    /// CGFloat = 2
  static let tdsXxxSmall: CGFloat = 2
    /// CGFloat = 4
  static let tdsXxSmall: CGFloat = 4
    /// CGFloat = 8
  static let tdsXSmall: CGFloat = 8
    /// CGFloat = 12
  static let tdsSmall: CGFloat = 12
    /// CGFloat = 16
  static let tdsMedium: CGFloat = 16
    /// CGFloat = 24
  static let tdsLarge: CGFloat = 24
    /// CGFloat = 32
  static let tdsXlarge: CGFloat = 32
    /// CGFloat = 48
  static let tdsXxlarge: CGFloat = 48
  
  func clip(lower: CGFloat, upper: CGFloat) -> CGFloat {
    CGFloat.maximum(lower, CGFloat.minimum(self, upper))
  }
}
