//
//  TertiaryButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func tertiaryButton(size: ButtonSize) -> some View {
    modifier(TertiaryButtonModifier(size: size))
  }
}

struct TertiaryButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(TertiaryButtonStyle(size: size))
  }
}

struct TertiaryButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    TertiaryButton(size: size, configuration: configuration)
  }
  
  struct TertiaryButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      if isEnabled {
        configuration.label.font(.body).bold()
          .padding(.horizontal, size.paddingHorizontal)
          .padding(.vertical, size.paddingVertical)
          .background(Color(uiColor: .systemBackground))
          .foregroundColor(.blue)
          .overlay(
            RoundedRectangle(cornerRadius: size.cornerRadius)
              .stroke(.blue, lineWidth: 1.5)
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
    }.tertiaryButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.tertiaryButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.tertiaryButton(size: .small)
      .padding(.bottom, .tdsMedium)
  }
}
