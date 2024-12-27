//
//  SuccessButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func successButton(size: ButtonSize) -> some View {
    modifier(SuccessButtonModifier(size: size))
  }
}

struct SuccessButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(SuccessButtonStyle(size: size))
  }
}

struct SuccessButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    SuccessButton(size: size, configuration: configuration)
  }
  
  struct SuccessButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      if isEnabled {
        configuration.label.font(.body).bold()
          .padding(.horizontal, size.paddingHorizontal)
          .padding(.vertical, size.paddingVertical)
          .background(.green)
          .foregroundColor(.white)
          .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
      } else {
        configuration
          .label
          .disabledButtonStyle(size: size)
      }
    }
  }
}

#Preview ("Success button") {
  VStack {
    Button { } label: {
      Text("Large button")
    }.successButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.successButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.successButton(size: .small)
      .padding(.bottom, .tdsMedium)
  }
}
