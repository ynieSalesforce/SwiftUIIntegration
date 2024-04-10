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
      
      LoadingSectionView(
        model: $viewModel.forecastData,
        loadingContent: {
          ProgressView().padding()
        }, content: { model in
          forecastWeatherView(forecastWeather: model)
        }, errorContent: { error in
          ErrorView(error: error)
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
      Button(action: {
        loadData(input: Addresses[0])
      }, label: {
        Text("Address 1")
      }).padding()
      
      Button(action: {
        loadData(input: Addresses[1])
      }, label: {
        Text("Address 2")
      }).padding()
      
      Button(action: {
        loadData(input: Addresses[2])
      }, label: {
        Text("Address 3")
      }).padding()
    }
  }
  
  private func loadData(input: String) {
    viewModel.fetchCurrentWeather(input: input)
    viewModel.fetchForecast(input: input)
  }
}
