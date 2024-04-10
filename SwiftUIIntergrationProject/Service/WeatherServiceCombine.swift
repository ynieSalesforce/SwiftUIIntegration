//
//  WeatherServiceCombine.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import Combine
import ComposableArchitecture

struct WeatherServiceCombine {
  var retrieveWeatherForecast: (LoadCriteria) -> DataPublisher<ForecastDisplayData?>
  var retrieveCurrentWeather: (LoadCriteria) -> DataPublisher<CurrentWeatherDisplayData?>
}

extension DependencyValues {
  var weatherServiceCombine: WeatherServiceCombine {
    get {
      self[WeatherServiceCombine.self]
    }
    set {
      self[WeatherServiceCombine.self] = newValue
    }
  }
}
extension WeatherServiceCombine: DependencyKey {
  static let liveValue = Self(
    retrieveWeatherForecast: { loadCriteria in
      WeatherServiceCombine.retrieveWeatherForecast(from: loadCriteria)
    },
    retrieveCurrentWeather: { loadCriteria in
      WeatherServiceCombine.retrieveCurrentWeather(from: loadCriteria)
    }
  )
  
  static let testValue: WeatherServiceCombine = Self(
    retrieveWeatherForecast: { _ in
      Just(ForecastDisplayData.createMock()).eraseToAnyPublisher()
    }, retrieveCurrentWeather: { _ in
      Just(CurrentWeatherDisplayData.createMock()).eraseToAnyPublisher()
    }
  )
  
  static let previewValue: WeatherServiceCombine = Self(
    retrieveWeatherForecast: { _ in
      Just(ForecastDisplayData.createMock()).eraseToAnyPublisher()
    }, retrieveCurrentWeather: { _ in
      Just(CurrentWeatherDisplayData.createMock()).eraseToAnyPublisher()
    }
  )
}

extension WeatherServiceCombine {
  static func retrieveWeatherForecast(from loadCriteria: LoadCriteria) -> DataPublisher<ForecastDisplayData?> {
    guard let unwrappedURL = weatherServiceUrl(path: "forecast", loadCriteria: loadCriteria) else { return Just(nil ).eraseToAnyPublisher() }
    
    return URLSession.shared.dataTaskPublisher(for: unwrappedURL)
      .map { $0.data }
      .decode(type: ForecastDisplayData?.self, decoder: JSONDecoder())
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }
  
  static func retrieveCurrentWeather(from loadCriteria: LoadCriteria) -> DataPublisher<CurrentWeatherDisplayData?> {
    guard let unwrappedURL = weatherServiceUrl(path: "weather", loadCriteria: loadCriteria) else { return Just(nil ).eraseToAnyPublisher() }
    
    return URLSession.shared.dataTaskPublisher(for: unwrappedURL)
      .map { $0.data }
      .decode(type: CurrentWeatherDisplayData?.self, decoder: JSONDecoder())
      .replaceError(with: nil)
      .eraseToAnyPublisher()
  }
}
