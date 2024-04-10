//
//  SwiftUIMixViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import Combine
import SwiftUI
import ReactiveSwift

class SwiftUIMixViewModel: ObservableObject {
  @Published var currentWeatherData: ViewDataState<CurrentWeatherDisplayData> = .loading
  @Published var forecastData: ViewDataState<ForecastDisplayData> = .loading
  
  func fetchCurrentWeather(input: String) {
    Environment.current.addressService
      .coordinates(input)
      .skipNil()
      .map(LoadCriteria.init)
      .flatMap(.latest, Environment.current.weatherServiceReactive.retrieveCurrentWeather)
      .start(on: Environment.current.scheduler)
      .observe(on: UIScheduler())
      .materialize()
      .startWithValues { [weak self] event in
        switch event {
        case .value(let data):
          self?.currentWeatherData = .dataLoaded(data)
        case .failed(_):
          self?.currentWeatherData = .error
        default: return
        }
      }
  }
  
  func fetchForecast(input: String) {
    Environment.current.addressService
      .coordinates(input)
      .skipNil()
      .map(LoadCriteria.init)
      .flatMap(.latest, Environment.current.weatherServiceReactive.retrieveWeatherForecast)
      .start(on: Environment.current.scheduler)
      .observe(on: UIScheduler())
      .materialize()
      .startWithValues { [weak self] event in
        switch event {
        case .value(let data):
          self?.forecastData = .dataLoaded(data)
        case .failed(_):
          self?.currentWeatherData = .error
        default: return
        }
      }
  }
}

typealias AsyncResultStream<T> = AsyncStream<Result<T, Error>>
