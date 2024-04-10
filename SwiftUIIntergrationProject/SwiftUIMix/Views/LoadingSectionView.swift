//
//  LoadingSectionView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import SwiftUI

struct LoadingSectionView<
  LoadingView: View,
  ContentView: View,
  Model: Equatable,
  ErrorContent: View
>: View {
  let content: (Model) -> ContentView
  let errorContent: () -> ErrorContent
  let loadingContent: () -> LoadingView
  
  @Binding var state: ViewDataState<Model>
  
  init(
    model: Binding<ViewDataState<Model>>,
    @ViewBuilder loadingContent: @escaping () -> LoadingView,
    @ViewBuilder content: @escaping (Model) -> ContentView,
    @ViewBuilder errorContent: @escaping () -> ErrorContent
  ) {
    _state = model
    self.content = content
    self.errorContent = errorContent
    self.loadingContent = loadingContent
  }
  
  var body: some View {
    switch state {
    case .loading:
      loadingContent()
    case let .dataLoaded(model):
      content(model)
    case .error:
      errorContent()
    case .empty:
      EmptyView()
    }
  }
}

struct ErrorView: View {
  var body: some View {
    Text("Error View")
      .font(.title)
      .padding()
      .foregroundColor(.primary)
  }
}
