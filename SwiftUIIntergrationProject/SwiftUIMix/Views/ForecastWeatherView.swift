//
//  ForecastWeatherView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import SwiftUI

struct ForecastWeatherView: View {
  var forecast: ForecastDisplayData
  @State private var cellMaxHeight: CGFloat?
  private var sectionHeight: CGFloat? {
    guard let height = cellMaxHeight else { return nil }
    return height + .tdsMedium
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Text("5 day forecast")
        .font(.title)
        .padding(.vertical, .tdsMedium)
      
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(
          spacing: .tdsSmall
        ) {
          ForEach(forecast.list) { viewData in
            ForecastWeatherCell(listItem: viewData)
              .readHeight()
              .frame(height: cellMaxHeight)
          }.fixedSize(horizontal: false, vertical: true)
          
        }.padding(.horizontal, .tdsMedium)
          .scrollTargetLayout()
          .frame(height: sectionHeight)
          .onPreferenceChange(CellHeightPreferenceKey.self) {
            guard $0 > 1 else { return }
            cellMaxHeight = $0
          }
      }.scrollTargetBehavior(.viewAligned)
    }
  }
}

struct ForecastWeatherCell: View {
  var listItem: List
  
  var body: some View {
    VStack(spacing: 0) {
      Text(listItem.displayDate)
        .padding()
        .font(.title3)
      Text("Temperature: \(listItem.temperatures.temp.formattedRoundedWholeNumber()) F")
        .padding()
        .font(.body)
      
      Text("Weather: \(listItem.weather.first?.description ?? "")")
        .padding()
        .font(.body)
      
      if let rain = listItem.rain {
        Text("Wind: \(listItem.wind.speed.formattedRoundedWholeNumber()) mph")
          .padding()
          .font(.body)
        
        Text("Wind direction: \(listItem.wind.direction)")
          .padding()
          .font(.body)
        
        Text("Rain: \(rain.the3H.formattedRoundedWholeNumber()) inches")
          .padding()
          .font(.body)
          .frame(maxHeight: .infinity, alignment: .bottom)
      } else {
        Text("Wind direction: \(listItem.wind.direction)")
          .padding()
          .font(.body)
        
        Text("Wind: \(listItem.wind.speed.formattedRoundedWholeNumber()) mph")
          .padding()
          .font(.body)
          .frame(maxHeight: .infinity, alignment: .bottom)
      }
      
      
    }.border(Color.black)
    
  }
}

extension List: Identifiable {
  public typealias ID = String
  var id: String {
    return "\(dt)"
  }
}

#if DEBUG
import PreviewSnapshots

struct ForecastWeatherView_Previews: PreviewProvider {
  static var previews: some View {
    snapshots.previews.previewLayout(.sizeThatFits)
  }
  
  static var snapshots: PreviewSnapshots<ForecastDisplayData> {
    PreviewSnapshots(configurations: [
      .init(name: "data Loads state", state: ForecastDisplayData.createMock()!)
    ]) { state in
      ForecastWeatherView(forecast: state)
    }
  }
}

#endif
