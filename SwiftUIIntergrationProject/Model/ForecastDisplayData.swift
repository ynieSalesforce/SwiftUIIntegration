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
  let coord: Coord
  let country: String
  let population, timezone, sunrise, sunset: Int
}

  // MARK: - Coord
struct Coord: Codable {
  let lat, lon: Double
}

  // MARK: - List
struct List: Codable {
  let dt: Int
  let temperatures: Temperature
  let weather: [Weather]
  let clouds: Clouds
  let wind: Wind
  let visibility: Int
  let pop: Double
  let rain: Rain?
  let dtTxt: String
  
  enum CodingKeys: String, CodingKey {
    case temperatures = "main"
    case dt, weather, clouds, wind, visibility, pop
    case rain
    case dtTxt = "dt_txt"
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
  // MARK: - Clouds
struct Clouds: Codable {
  let all: Int
}

  // MARK: - MainClass
struct Temperature: Codable {
  let temp, feelsLike, tempMin, tempMax: Double
  let pressure, seaLevel, grndLevel, humidity: Int
  let tempKf: Double
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure
    case seaLevel = "sea_level"
    case grndLevel = "grnd_level"
    case humidity
    case tempKf = "temp_kf"
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
