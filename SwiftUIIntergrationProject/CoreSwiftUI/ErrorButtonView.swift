//
//  ErrorButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func errorButton(size: ButtonSize) -> some View {
    modifier(ErrorButtonModifier(size: size))
  }
}

struct ErrorButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(ErrorButtonStyle(size: size))
  }
}

struct ErrorButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    ErrorButton(size: size, configuration: configuration)
  }
  
  struct ErrorButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      if isEnabled {
        configuration.label.font(.body).bold()
          .padding(.horizontal, size.paddingHorizontal)
          .padding(.vertical, size.paddingVertical)
          .background(Color(uiColor: .systemBackground))
          .foregroundColor(.red)
          .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
              .stroke(.red, lineWidth: 1.5)
          )
      } else {
        configuration
          .label
          .disabledButtonStyle(size: size)
      }
    }
  }
}

#Preview ("Tertiary button") {
  VStack {
    Button { } label: {
      Text("Large button")
    }.errorButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.errorButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.errorButton(size: .small)
      .padding(.bottom, .tdsMedium)
  }
}
