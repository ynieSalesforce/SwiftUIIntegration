//
//  SectionTabViewExample.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SectionTabViewExample: View {
  @Bindable var store: StoreOf<SectionTabStoreExample>
  @State var height: CGFloat? = 0
  
  var body: some View {
    VStack {
      SectionBasedTabBarView(
        store: store.scope(state: \.tabState, action: \.tabBarAction),
        cellMaxHeight: $height,
        loadSectionView: sectionView)
      .padding(.bottom, .tdsMedium)
      
      Text("To ensure that spacing is correct")
        .foregroundColor(.secondary)
        .background(Color.blue)
      
      Spacer()
    }
  }
  
  @ViewBuilder
  private func sectionView(tabBarType: TabSectionExample) -> some View {
    VStack(spacing: .tdsNone) {
      switch tabBarType {
      case .first:
        currentWeatherView()
      case .second:
        forecastView()
      }
    }
  }
  
  @ViewBuilder 
  private func currentWeatherView() -> some View {
    let data = CurrentWeatherDisplayData.createMock()!
    CurrentWeatherView(currentWeather: data)
  }
  
  @ViewBuilder
  private func forecastView() -> some View {
    let data = ForecastDisplayData.createMock()?.list.first
    ForecastWeatherCell(listItem: data!)
  }
}

#Preview {
  SectionTabViewExample(
    store: .init(initialState: .init(
      tabState:
          .init(types: [TabSectionExample.first, TabSectionExample.second], selectedTab: .first)), reducer: {
      SectionTabStoreExample()
    }), height: 0)
}
