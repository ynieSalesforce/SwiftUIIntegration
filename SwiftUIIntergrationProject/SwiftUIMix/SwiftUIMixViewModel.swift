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
          self?.weatherData = .error(nil)
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

/**
 @MainActor
 func fetchContinueData(refresh: Bool = false) async {
  for await data in doFetchAsyncStreamFunction(refresh) {
    switch data {
    case let .success(model):
      if model.sections.isEmpty {
        continueLearning = .empty
      } else {
        continueLearning = .dataLoaded(model)
      }
    case let .failure(error):
      continueLearning.errorLoaded(with: error)
    }
    if refresh { return }
  }
 }
 
 /// Returns stream of of data
 /// - Parameter refresh:
 private func doFetchAsyncStreamFunction(_: Bool) -> AsyncResultStream<ContainerModel> {
  return AsyncStream { continuation in
    Environment.current.services.getSomeUserData()
    .start(on: Environment.current.scheduler)
    .observe(on: UIScheduler())
    .materialize()
    .startWithValues { [weak self] event in
      switch event {
      case let .value(data):
        let data = mapDataFunction(data: data)
        continuation.yield(.success(data))
      case let .failed(error):
        continuation.yield(.failure(error))
      default: break
    }
  }
 }
 */
