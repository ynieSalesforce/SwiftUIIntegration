//
//  WeatherStoreTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/11/24.
//

import Foundation
import Quick
import Nimble
import ComposableArchitecture

@testable import SwiftUIIntergrationProject

@MainActor
final class WeatherStoreTests: QuickSpec {
  override class func spec() {
    describe("Composable Store tests") {
      var store: StoreOf<WeatherStore>!
      
      beforeEach {
        Environment.current = .mock()
        store = .init(initialState: .init(), reducer: {
          WeatherStore.init()
        })
      }
      
      it("Loads data") {
        expect(store.state.weatherState) == .loading
        store.send(.loadWeather("test"))
        
        switch store.state.weatherState {
        case .dataLoaded(let data):
          expect(data.forecast.list.count) > 0
          expect(data.currentWeather.name.count) > 0
        case .loading:
          print("Loading")
        case .empty:
          print("Empty")
        default:
          fail("incorrect state")
        }
      }
    }
  }
}
