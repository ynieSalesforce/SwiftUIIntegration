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
  @State private var selectedAddress: String = Addresses[0]
  
  var body: some View {
    LoadingSectionView(
      model: $viewModel.weatherData,
      loadingContent: {
        ProgressView().padding().onLoad {
          loadData()
        }
      }, content: { model in
        weatherView(displayData: model)
      }, errorContent: {
        ErrorView()
      })
  }
  
  @ViewBuilder
  private func weatherView(displayData: WeatherDisplayData) -> some View {
    ScrollView {
      VStack(spacing: 0) {
        currentWeatherView(currentWeather: displayData.currentWeather)
        forecastWeatherView(forecastWeather: displayData.forecast)
      }
    }.refreshable {
      loadData()
    }
  }
  
  @ViewBuilder
  private func currentWeatherView(currentWeather: CurrentWeatherDisplayData) -> some View {
    VStack(spacing: 0) {
      weatherSelectionView()
        .padding(.bottom, .tdsMedium)
      CurrentWeatherView(currentWeather: currentWeather)
    }
  }
  
  @ViewBuilder
  private func forecastWeatherView(forecastWeather: ForecastDisplayData) -> some View {
    ForecastWeatherView(forecast: forecastWeather)
  }
  
  @ViewBuilder
  private func weatherSelectionView() -> some View {
    HStack {
      Button("Address 1") {
        selectedAddress = Addresses[0]
        loadData()
      }.buttonStyle(GrowingButton())
      
      Button("Address 2") {
        selectedAddress = Addresses[1]
        loadData()
      }.buttonStyle(GrowingButton())
      .padding(.horizontal, .tdsSmall)
      
      Button("Address 3") {
        selectedAddress = Addresses[2]
        loadData()
      }.buttonStyle(GrowingButton())
    }
  }
  
  private func loadData() {
    viewModel.fetchWeatherDisplayData(input: selectedAddress)
  }
}
