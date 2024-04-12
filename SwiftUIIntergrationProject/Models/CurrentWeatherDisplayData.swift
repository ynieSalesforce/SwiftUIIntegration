//
//  CurrentWeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation

  // MARK: - WeatherDisplayData
struct CurrentWeatherDisplayData: Codable, Equatable {
  let weather: [Weather]
  let main: Main
  let wind: Wind
  let dt: Int
  let id: Int
  let name: String
}

  // MARK: - Main
struct Main: Codable, Equatable {
  let temp, feelsLike: Double
  let humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case humidity
  }
}
