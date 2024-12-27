//
//  THButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public enum ButtonSize {
  case small
  case medium
  case large
  
  var controlSize: ControlSize {
    switch self {
    case .small:
      return .small
    case .medium:
      return .small
    case .large:
      return .large
    }
  }
  
  var paddingVertical: CGFloat {
    switch self {
    case .small:
      return .tdsXxxSmall
    case .medium:
      return 7
    case .large:
      return .tdsMedium
    }
  }
  
  var paddingHorizontal: CGFloat {
    switch self {
    case .small:
      return 10
    case .medium:
      return 14
    case .large:
      return 20
    }
  }
  
  var cornerRadius: CGFloat {
    switch self {
    case .small:
      return 17
    case .medium:
      return 17
    case .large:
      return .tdsSmall
    }
  }
}

struct DisabledButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .font(.body).bold()
      .padding(.horizontal, size.paddingHorizontal)
      .padding(.vertical, size.paddingVertical)
      .background(.background.secondary)
      .foregroundColor(.secondary)
      .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
  }
}

extension View {
  func disabledButtonStyle(size: ButtonSize) -> some View {
    modifier(DisabledButtonModifier(size: size))
  }
}
