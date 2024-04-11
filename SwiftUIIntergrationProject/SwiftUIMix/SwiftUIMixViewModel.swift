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
  @Published var weatherData: ViewDataState<WeatherDisplayData> = .loading
  
  func fetchWeatherDisplayData(input: String) {
    let current = fetchCurrentWeather(input: input)
    let forecast = fetchForecast(input: input)
    current.combineLatest(with: forecast).map(WeatherDisplayData.init)
      .materialize()
      .startWithValues { [weak self] event in
        switch event {
        case .value(let value):
          self?.weatherData = .dataLoaded(value)
        case .failed:
          self?.weatherData = .error
        default: break
        }
      }
  }
  
  private func fetchCurrentWeather(input: String) -> DataProducer<CurrentWeatherDisplayData>  {
    Environment.current.addressService
      .coordinates(input)
      .skipNil()
      .map(LoadCriteria.init)
      .flatMap(.latest, Environment.current.weatherServiceReactive.retrieveCurrentWeather)
      .start(on: Environment.current.scheduler)
      .observe(on: UIScheduler())
  }
  
  private func fetchForecast(input: String) -> DataProducer<ForecastDisplayData> {
    Environment.current.addressService
      .coordinates(input)
      .skipNil()
      .map(LoadCriteria.init)
      .flatMap(.latest, Environment.current.weatherServiceReactive.retrieveWeatherForecast)
      .start(on: Environment.current.scheduler)
      .observe(on: UIScheduler())
  }
}

typealias AsyncResultStream<T> = AsyncStream<Result<T, Error>>
