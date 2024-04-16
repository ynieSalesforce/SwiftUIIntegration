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
  
  var body: some View {
    switch store.weatherState {
    case .dataLoaded(let weatherData):
      NavigationStack {
        ScrollView {
          VStack(content: {
            weatherSelectionView()
              .padding()
            CurrentWeatherView(currentWeather: weatherData.currentWeather)
            ForecastWeatherView(forecast: weatherData.forecast)
            
            Button("Show Address Details") {
              store.send(.hideContainerNav(true))
              store.send(.showWeatherDetails)
            }.buttonStyle(GrowingButton())
              .padding()
          })
        }.refreshable {
          store.send(.loadWeather)
        }
        .navigationDestination(
          item: $store.scope(state: \.destination?.additionalWeather, action: \.destination.additionalWeather)
        ) { store in
          ListWeatherView(store: store)
        }.onAppear {
          store.send(.hideContainerNav(false))
        }
      }
    case .loading:
      ProgressView().padding()
        .onLoad {
          store.send(.loadWeather)
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
        store.send(.selectWeather(Addresses[0]))
      }.buttonStyle(GrowingButton())
      
      Button("Address 2") {
        store.send(.selectWeather(Addresses[1]))
      }.buttonStyle(GrowingButton())
        .padding(.horizontal, .tdsSmall)
      
      Button("Address 3") {
        store.send(.selectWeather(Addresses[2]))
      }.buttonStyle(GrowingButton())
    }
  }
}
