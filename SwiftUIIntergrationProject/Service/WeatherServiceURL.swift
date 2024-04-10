//
//  WeatherServiceURL.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation

//Enter your Open weather API Key from: https://home.openweathermap.org/api_keys
func weatherServiceUrl(path: String, loadCriteria: LoadCriteria) -> URL? {
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
  return components.url
}
