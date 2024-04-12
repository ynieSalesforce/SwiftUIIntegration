//
//  WeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation

struct WeatherDisplayData: Equatable {
  let currentWeather: CurrentWeatherDisplayData
  let forecast: ForecastDisplayData
  
  init(currentWeather: CurrentWeatherDisplayData, forecast: ForecastDisplayData) {
    self.currentWeather = currentWeather
    self.forecast = forecast
  }
}
