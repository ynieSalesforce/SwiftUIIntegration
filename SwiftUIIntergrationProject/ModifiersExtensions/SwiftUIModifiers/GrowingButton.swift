//
//  GrowingButton.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import SwiftUI

struct GrowingButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding()
      .background(.blue)
      .foregroundStyle(.white)
      .clipShape(RoundedRectangle(cornerSize: .init(width: .tdsSmall, height: .tdsSmall)))
      .scaleEffect(configuration.isPressed ? 1.1 : 1)
      .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
  }
}
