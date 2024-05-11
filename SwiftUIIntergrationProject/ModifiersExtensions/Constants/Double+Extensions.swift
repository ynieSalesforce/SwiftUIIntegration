//
//  Double+Extensions.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/10/24.
//

import Foundation

extension Double {
  func formattedRoundedWholeNumber() -> String {
    Float(self.rounded()).formatted()
  }
}
