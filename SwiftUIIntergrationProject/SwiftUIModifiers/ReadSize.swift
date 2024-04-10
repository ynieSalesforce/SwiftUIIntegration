//
//  ReadSize.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import SwiftUI

  // Using Preference Key: https://www.swiftbysundell.com/questions/syncing-the-width-or-height-of-two-swiftui-views/
struct CellHeightPreferenceKey: PreferenceKey {
  static let defaultValue: CGFloat = 0
  
  static func reduce(
    value: inout CGFloat,
    nextValue: () -> CGFloat
  ) {
    value = max(value, nextValue())
  }
}

extension View {
  func readHeight() -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(
            key: CellHeightPreferenceKey.self,
            value: geometryProxy.size.height
          )
      }
    )
  }
  
  func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(
            key: CellHeightPreferenceKey.self,
            value: geometryProxy.size.height
          )
      }
    ).onPreferenceChange(CellHeightPreferenceKey.self, perform: onChange)
  }
}
