//
//  WeatherService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import ReactiveSwift

struct WeatherServiceReactive {
  var retrieveWeatherForecast: (LoadCriteria) -> DataProducer<ForecastDisplayData> = WeatherServiceReactive.retrieveWeatherForecast
  var retrieveCurrentWeather: (LoadCriteria) -> DataProducer<CurrentWeatherDisplayData> = WeatherServiceReactive.retrieveCurrentWeather
}

extension WeatherServiceReactive {
  static var live = WeatherServiceReactive()
}

extension WeatherServiceReactive {
  static func retrieveWeatherForecast(from loadCriteria: LoadCriteria) -> DataProducer<ForecastDisplayData> {
    guard let unwrappedURL = weatherServiceUrl(path: "forecast", loadCriteria: loadCriteria) else { return SignalProducer.empty }
    
    return URLSession.shared.reactive
      .data(with: URLRequest(url: unwrappedURL, cachePolicy: .reloadRevalidatingCacheData))
      .retry(upTo: 2)
      .flatMapError { error in
        return SignalProducer.init(error: error)
      }
      .flatMap(.latest, { (data, response) in
        do {
          let forecast = try JSONDecoder().decode(ForecastDisplayData.self, from: data)
          return .init(value: forecast)
        } catch (let error) {
          return .init(error: error)
        }
      })
      .observe(on: UIScheduler())
  }
  
  static func retrieveCurrentWeather(from loadCriteria: LoadCriteria) -> DataProducer<CurrentWeatherDisplayData> {
    guard let unwrappedURL = weatherServiceUrl(path: "weather", loadCriteria: loadCriteria) else { return SignalProducer.empty }
    
    return URLSession.shared.reactive
      .data(with: URLRequest(url: unwrappedURL, cachePolicy: .reloadRevalidatingCacheData))
      .retry(upTo: 2)
      .flatMapError { error in
        return SignalProducer.init(error: error)
      }
      .flatMap(.latest, { (data, response) in
        do {
          let forecast = try JSONDecoder().decode(CurrentWeatherDisplayData.self, from: data)
          return .init(value: forecast)
        } catch (let error) {
          return .init(error: error)
        }
      })
      .observe(on: UIScheduler())
  }
  
}
