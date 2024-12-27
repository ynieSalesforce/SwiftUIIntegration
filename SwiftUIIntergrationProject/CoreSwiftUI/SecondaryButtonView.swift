//
//  SecondaryButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func secondaryButton(size: ButtonSize) -> some View {
    modifier(SecondaryButtonModifier(size: size))
  }
}

struct SecondaryButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(SecondaryButtonStyle(size: size))
  }
}

struct SecondaryButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    SecondaryButton(size: size, configuration: configuration)
  }
  
  struct SecondaryButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      if isEnabled {
        configuration.label.font(.body).bold()
          .padding(.horizontal, size.paddingHorizontal)
          .padding(.vertical, size.paddingVertical)
          .background(.blue.opacity(0.15))
          .foregroundColor(.blue)
          .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
      } else {
        configuration
          .label
          .disabledButtonStyle(size: size)
      }
    }
  }
}

#Preview ("Secondary button") {
  VStack {
    Button { } label: {
      Text("Large button")
    }.secondaryButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.secondaryButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.secondaryButton(size: .small)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Large button")
    }.secondaryButton(size: .large).disabled(true)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Medium button")
    }.secondaryButton(size: .medium).disabled(true)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Small button")
    }.secondaryButton(size: .small).disabled(true)
      .padding(.bottom, .tdsMedium)
  }
}
