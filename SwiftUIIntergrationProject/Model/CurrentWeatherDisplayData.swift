//
//  CurrentWeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation

  // MARK: - WeatherDisplayData
struct CurrentWeatherDisplayData: Codable {
  let coord: Coord
  let weather: [Weather]
  let base: String
  let main: Main
  let visibility: Int
  let wind: Wind
  let clouds: Clouds
  let dt: Int
  let sys: Sys
  let timezone, id: Int
  let name: String
  let cod: Int
}

  // MARK: - Main
struct Main: Codable {
  let temp, feelsLike, tempMin, tempMax: Double
  let pressure, humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure, humidity
  }
}

  // MARK: - Sys
struct Sys: Codable {
  let type, id: Int
  let country: String
  let sunrise, sunset: Int
}
