//
//  PrimaryButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func primaryButton(size: ButtonSize) -> some View {
    modifier(PrimaryButtonModifier(size: size))
  }
}

struct PrimaryButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(PrimaryButtonStyle(size: size))
  }
}

struct PrimaryButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    PrimaryButton(size: size, configuration: configuration)
  }
  
  struct PrimaryButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    var body: some View {
      if isEnabled {
        configuration.label.font(.body).bold()
          .padding(.horizontal, size.paddingHorizontal)
          .padding(.vertical, size.paddingVertical)
          .background(.blue)
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

#Preview ("Primary button") {
  VStack {
    Button { } label: {
      Text("Large button")
    }.primaryButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.primaryButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.primaryButton(size: .small)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Large button")
    }.primaryButton(size: .large)
      .disabled(true)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Medium button")
    }.primaryButton(size: .medium)
      .disabled(true)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Small button")
    }.primaryButton(size: .small)
      .disabled(true)
      .padding(.bottom, .tdsMedium)
  }
}
