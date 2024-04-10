//
//  WeatherServiceMock.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation

@testable import SwiftUIIntergrationProject

extension WeatherServiceReactive {
  static var mock = WeatherServiceReactive(
    retrieveWeatherForecast: retrieveWeatherForecastMock,
    retrieveCurrentWeather: retrieveCurrentWeatherMock
  )
  
  static func retrieveWeatherForecastMock(from loadCriteria: LoadCriteria) -> DataProducer<ForecastDisplayData> {
    return .init(value: .createMock()!)
  }
  
  static func retrieveCurrentWeatherMock(from loadCriteria: LoadCriteria) -> DataProducer<CurrentWeatherDisplayData> {
    return .init(value: .createMock()!)
  }
}
