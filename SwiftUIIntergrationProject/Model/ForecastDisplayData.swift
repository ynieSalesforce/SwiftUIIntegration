//
//  WeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation

// Generated from: https://app.quicktype.io/
struct ForecastDisplayData: Codable {
  let cod: String
  let message, cnt: Int
  let list: [List]
  let city: City
}

  // MARK: - City
struct City: Codable {
  let id: Int
  let name: String
}

  // MARK: - List
struct List: Codable {
  let dt: Int
  let temperatures: Temperature
  let weather: [Weather]
  let wind: Wind
  let rain: Rain?
  
  enum CodingKeys: String, CodingKey {
    case temperatures = "main"
    case dt, weather, wind
    case rain
  }
}

extension List {
  var displayDate: String {
    let timeInterval = Date(timeIntervalSince1970: TimeInterval(dt))
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: timeInterval)
  }
}

  // MARK: - MainClass
struct Temperature: Codable {
  let temp, feelsLike: Double
  let humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case humidity
  }
}

  // MARK: - Rain
struct Rain: Codable {
  let the3H: Double
  
  enum CodingKeys: String, CodingKey {
    case the3H = "3h"
  }
}

  // MARK: - Weather
struct Weather: Codable {
  let id: Int
  let main: MainEnum
  let description, icon: String
}

enum MainEnum: String, Codable {
  case clear = "Clear"
  case clouds = "Clouds"
  case rain = "Rain"
}

  // MARK: - Wind
struct Wind: Codable {
  let speed: Double
  let deg: Int
}
