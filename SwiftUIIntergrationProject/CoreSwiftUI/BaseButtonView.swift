//
//  BaseButtonView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/26/24.
//

import Foundation
import SwiftUI

public extension View {
  func baseButton(size: ButtonSize) -> some View {
    modifier(BaseButtonModifier(size: size))
  }
}

struct BaseButtonModifier: ViewModifier {
  var size: ButtonSize
  
  func body(content: Content) -> some View {
    content
      .buttonStyle(BaseButtonStyle(size: size))
  }
}

struct BaseButtonStyle: ButtonStyle {
  var size: ButtonSize
  func makeBody(configuration: ButtonStyle.Configuration) -> some View {
    BaseButton(size: size, configuration: configuration)
  }
  
  struct BaseButton: View {
    var size: ButtonSize
    let configuration: ButtonStyle.Configuration
    @SwiftUI.Environment(\.isEnabled) private var isEnabled: Bool
    
    var body: some View {
      if isEnabled {
        configuration.label
          .font(.body).bold()
          .foregroundColor(.blue)
      } else {
        configuration
          .label
          .font(.body).bold()
          .foregroundColor(.secondary)
      }
    }
  }
}

#Preview ("Base button") {
  VStack {
    Button { } label: {
      Text("Large button")
    }.baseButton(size: .large)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Medium button")
    }.baseButton(size: .medium)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Small button")
    }.baseButton(size: .small)
      .padding(.bottom, .tdsMedium)
    
    Button { } label: {
      Text("Disabled Large button")
    }.baseButton(size: .large)
      .padding(.bottom, .tdsMedium)
      .disabled(true)
    
    Button { } label: {
      Text("Disabled Medium button")
    }.baseButton(size: .medium)
      .padding(.bottom, .tdsMedium)
      .disabled(true)
    
    Button { } label: {
      Text("Disabled Small button")
    }.baseButton(size: .small)
      .padding(.bottom, .tdsMedium)
      .disabled(true)
  }
}
