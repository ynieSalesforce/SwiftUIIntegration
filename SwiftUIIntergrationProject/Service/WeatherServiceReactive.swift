//
//  WeatherService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import ReactiveSwift
import Alamofire

struct WeatherServiceReactive {
  var retrieveWeatherForecast: (LoadCriteria) -> DataProducer<ForecastDisplayData> = WeatherServiceReactive.retrieveWeatherForecast
  var retrieveCurrentWeather: (LoadCriteria) -> DataProducer<CurrentWeatherDisplayData> = WeatherServiceReactive.retrieveCurrentWeather
}

extension WeatherServiceReactive {
  static var live = WeatherServiceReactive()
}

extension WeatherServiceReactive {
  static func retrieveWeatherForecast(from loadCriteria: LoadCriteria) -> DataProducer<ForecastDisplayData> {
    guard let unwrappedURL = url(path: "forecast", loadCriteria: loadCriteria) else { return SignalProducer.empty }
    
    return URLSession.shared.reactive
      .data(with: URLRequest(url: unwrappedURL))
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
    guard let unwrappedURL = url(path: "weather", loadCriteria: loadCriteria) else { return SignalProducer.empty }
    
    return URLSession.shared.reactive
      .data(with: URLRequest(url: unwrappedURL))
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

private func url(path: String, loadCriteria: LoadCriteria) -> URL? {
  var components = URLComponents()
  components.scheme = "https"
  components.host = "api.openweathermap.org"
  components.path = "/data/2.5/\(path)"
  components.queryItems = [
    URLQueryItem(name: "lat", value: "\(loadCriteria.location.coordinate.latitude)"),
    URLQueryItem(name: "lon", value: "\(loadCriteria.location.coordinate.longitude)"),
    URLQueryItem(name: "appid", value: openWeatherAPIKey),
    URLQueryItem(name: "units", value: "imperial")
  ]
  return try? components.asURL()
}
