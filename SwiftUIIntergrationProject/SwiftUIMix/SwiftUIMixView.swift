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
        }, errorContent: {
          ErrorView()
        })
      
      LoadingSectionView(
        model: $viewModel.forecastData,
        loadingContent: {
          ProgressView().padding()
        }, content: { model in
          forecastWeatherView(forecastWeather: model)
        }, errorContent: {
          ErrorView()
        })
      
      Spacer()
    }.onLoad {
      loadData(input: Addresses[0])
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
        loadData(input: Addresses[0])
      }.buttonStyle(GrowingButton())
      
      Button("Address 2") {
        loadData(input: Addresses[1])
      }.buttonStyle(GrowingButton())
      .padding(.horizontal, .tdsSmall)
      
      Button("Address 3") {
        loadData(input: Addresses[2])
      }.buttonStyle(GrowingButton())
    }
  }
  
  private func loadData(input: String) {
    viewModel.fetchCurrentWeather(input: input)
    viewModel.fetchForecast(input: input)
  }
}
