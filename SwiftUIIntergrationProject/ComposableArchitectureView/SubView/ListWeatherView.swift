//
//  ListWeatherView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/15/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ListWeatherView: View {
  @State var store: StoreOf<ListWeatherStore>
  
  var body: some View {
    switch store.weather {
    case .loading:
      ProgressView().padding()
        .onLoad {
          store.send(.loadData)
        }
    case .dataLoaded(let data):
      Text(data.currentWeather.name)
    case .error:
      ErrorView()
    case .empty:
      EmptyView()
    }
  }
}
