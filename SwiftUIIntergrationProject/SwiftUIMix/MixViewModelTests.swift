//
//  MixViewModelTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import Quick
import Nimble
import ReactiveSwift
import ReactiveCocoa

@testable import SwiftUIIntergrationProject

final class MixViewModelTests: QuickSpec {
  override class func spec() {
    describe("Mix View Model tests") {
      var viewModel: SwiftUIMixViewModel!
      let scheduler = TestScheduler()
      
      beforeEach {
        Environment.current = .mock()
        Environment.current.scheduler = scheduler
        viewModel = .init()
      }
      
      it("Loads data") {
        viewModel.fetchWeatherDisplayData(input: "test")
        scheduler.run()
        
        switch viewModel.weatherData {
        case .dataLoaded(let data):
          expect(data.forecast.list.count) > 0
          expect(data.currentWeather.name.count) > 0
        default:
          fail("incorrect state")
        }
      }
      
      it("handles error") {
        Environment.current.weatherServiceReactive.retrieveCurrentWeather = { _ in
            .init(error: TestError.unableToLoad)
        }
        
        Environment.current.weatherServiceReactive.retrieveWeatherForecast = { _ in
            .init(error: TestError.unableToLoad)
        }
        viewModel.fetchWeatherDisplayData(input: "test")
        scheduler.run()
        
        switch viewModel.weatherData {
        case .error:
          print("Correct state loaded")
        default:
          fail("incorrect state")
        }
      }
    }
  }
}

enum TestError: Error {
  case unableToLoad
}
