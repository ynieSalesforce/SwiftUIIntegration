//
//  SwiftUIMixView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import SwiftUI

struct SwiftUIMixView: View {
  @ObservedObject var viewModel: SwiftUIMixViewModel
  
  var body: some View {
    VStack(spacing: 0) {
      LoadingSectionView(
        model: $viewModel.currentWeatherData,
        loadingContent: {
          ProgressView().padding()
        }, content: { model in
          currentWeatherView(currentWeather: model)
        }, errorContent: { error in
          ErrorView(error: error)
        })
      
      switch viewModel.forecastData {
      case .loading:
        ProgressView().padding()
      case .dataLoaded(let data):
        forecastWeatherView(forecastWeather: data)
      case .error(let error):
        ErrorView(error: error)
      default: EmptyView()
      }
    }.onLoad {
      viewModel.fetchCurrentWeather(input: Addresses[0])
      viewModel.fetchForecast(input: Addresses[1])
    }
  }
  
  @ViewBuilder
  private func currentWeatherView(currentWeather: CurrentWeatherDisplayData) -> some View {
    VStack(spacing: 0) {
      Text(currentWeather.name)
    }
  }
  
  @ViewBuilder
  private func forecastWeatherView(forecastWeather: ForecastDisplayData) -> some View {
    VStack(spacing: 0) {
      Text("currentWeather.list.count")
    }
  }
}

struct ErrorView: View {
  let error: Error
  
  var body: some View {
    Text(error.localizedDescription)
  }
}

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
