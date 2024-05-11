//
//  CurrentWeatherView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import SwiftUI

struct CurrentWeatherView: View {
  var currentWeather: CurrentWeatherDisplayData
  
  var body: some View {
    VStack(spacing: .zero) {
      Text(currentWeather.name)
        .font(.title)
        .foregroundColor(.primary)
        .padding([.bottom, .top], 16)
      Text("Current weather: \(currentWeather.weather.first!.description)")
        .font(.title3)
        .foregroundColor(.primary)
        .padding(.bottom, 16)
      
      Text("Temperature: \(currentWeather.main.temp.formattedRoundedWholeNumber()) F")
        .font(.title3)
        .foregroundColor(.primary)
        .padding(.bottom, 16)
      
      Text("Wind: \(currentWeather.wind.speed.formattedRoundedWholeNumber()) mph")
        .font(.title3)
        .foregroundColor(.primary)
        .padding(.bottom, 16)
      
      Text("Wind direction: \(currentWeather.wind.direction)")
        .font(.title3)
        .foregroundColor(.primary)
        .padding(.bottom, 16)
    }
  }
}

#if DEBUG
import PreviewSnapshots

struct CurrentWeatherView_Previews: PreviewProvider {
  static var previews: some View {
    snapshots.previews.previewLayout(.sizeThatFits)
  }
  
  static var snapshots: PreviewSnapshots<CurrentWeatherDisplayData> {
    PreviewSnapshots(configurations: [
      .init(name: "data Loads state", state: CurrentWeatherDisplayData.createMock()!)
    ]) { state in
      CurrentWeatherView(currentWeather: state)
    }
  }
}

#endif
