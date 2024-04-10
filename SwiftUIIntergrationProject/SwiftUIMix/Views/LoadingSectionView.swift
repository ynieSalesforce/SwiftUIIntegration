//
//  LoadingSectionView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import SwiftUI

protocol LoadingSectionData<Model>: ObservableObject {
  associatedtype Model
  var state: ViewDataState<Model> { get set }
}

struct LoadingSectionView<
  LoadingView: View,
  ContentView: View,
  Model,
  ErrorContent: View
>: View {
  let content: (Model) -> ContentView
  let errorContent: (Error) -> ErrorContent
  let loadingContent: () -> LoadingView
  
  @Binding var state: ViewDataState<Model>
  
  init(
    model: Binding<ViewDataState<Model>>,
    @ViewBuilder loadingContent: @escaping () -> LoadingView,
    @ViewBuilder content: @escaping (Model) -> ContentView,
    @ViewBuilder errorContent: @escaping (Error) -> ErrorContent
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
    case let .error(error):
      errorContent(error)
    case .empty:
      EmptyView()
    }
  }
}

struct ErrorView: View {
  let error: Error
  
  var body: some View {
    Text(error.localizedDescription)
  }
}
