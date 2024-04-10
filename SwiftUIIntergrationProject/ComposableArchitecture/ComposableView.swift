//
//  ComposableView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct ComposableView: View {
  @State var store: StoreOf<WeatherStore>
  @State var selectedWeather: String = Addresses[0]
  
  init(store: StoreOf<WeatherStore>) {
    self.store = store
  }
  
  var body: some View {
    switch store.weatherState {
    case .dataLoaded(let weatherData):
      ScrollView {
        VStack(content: {
          weatherSelectionView()
            .padding()
          CurrentWeatherView(currentWeather: weatherData.currentWeather)
          ForecastWeatherView(forecast: weatherData.forecast)
        })
      }.refreshable {
        store.send(.loadWeather(selectedWeather))
      }
    case .loading:
      ProgressView().padding()
        .onLoad {
          store.send(.loadWeather(selectedWeather))
        }
    case .error:
      ErrorView()
    case .empty:
      EmptyView()
    }
  }
  
  @ViewBuilder
  private func weatherSelectionView() -> some View {
    HStack {
      Button("Address 1") {
        selectedWeather = Addresses[0]
        store.send(.loadWeather(Addresses[0]))
      }.buttonStyle(GrowingButton())
      
      Button("Address 2") {
        selectedWeather = Addresses[1]
        store.send(.loadWeather(Addresses[1]))
      }.buttonStyle(GrowingButton())
        .padding(.horizontal, .tdsSmall)
      
      Button("Address 3") {
        selectedWeather = Addresses[2]
        store.send(.loadWeather(Addresses[2]))
      }.buttonStyle(GrowingButton())
    }
  }
}
