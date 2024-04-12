//
//  WeatherStoreTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/11/24.
//

import Foundation
import Quick
import Nimble
import Combine
import ComposableArchitecture

@testable import SwiftUIIntergrationProject

@MainActor
final class WeatherStoreTests: QuickSpec {
  override class func spec() {
    describe("Composable Store tests") {
      var store: StoreOf<WeatherStore>!
      let runLoop: TestScheduler = DispatchQueue.test
      
      beforeEach {
        Environment.current = .mock()
        Environment.current.combineScheduler = runLoop.eraseToAnyScheduler()
        store = .init(initialState: .init(), reducer: {
          WeatherStore.init()
        })
      }
      
      it("Loads data") {
        expect(store.state.weatherState) == .loading
        store.send(.loadWeather)
        runLoop.run()
        
        switch store.state.weatherState {
        case .dataLoaded(let data):
          expect(data.forecast.list.count) > 0
          expect(data.currentWeather.name.count) > 0
        default:
          fail("incorrect state")
        }
      }
      
      
      it("Handles changing address") {
        let newAddress = "New Address"
        expect(store.state.weatherState) == .loading
        
        store.send(.selectWeather(newAddress))
        runLoop.run()
        
        switch store.state.weatherState {
        case .dataLoaded:
          break
        default:
          fail("incorrect state")
        }
        expect(store.state.selectedAddress) == newAddress
      }
      
      it("Handles error") {
        store = .init(initialState: .init(), reducer: {
          WeatherStore.init()
        }, withDependencies: { input in
          input.weatherServiceCombine = .init(
            retrieveWeatherForecast: { _ in
              Fail(error: SimpleError()).eraseToAnyPublisher()
            }, retrieveCurrentWeather: { _ in
              Fail(error: SimpleError()).eraseToAnyPublisher()
            })
        })
        
        store.send(.loadWeather)
        runLoop.run()
        
        switch store.state.weatherState {
        case .error:
          break
        default:
          fail("incorrect state")
        }
      }
    }
  }
}
