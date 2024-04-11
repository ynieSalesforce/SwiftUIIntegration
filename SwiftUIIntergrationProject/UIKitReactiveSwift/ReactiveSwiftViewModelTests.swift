//
//  ReactiveSwiftViewModelTests.swift
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

final class ReactiveSwiftViewModelTests: QuickSpec {
  override class func spec() {
    describe("Reactive Swift View Model tests") {
      var subject: ReactiveSwiftViewModel.Output!
      var currentWeatherObserver: TestObserver<CurrentWeatherDisplayData, Never>!
      var forecastObserver: TestObserver<ForecastDisplayData, Never>!
      var isLoadingObserver: TestObserver<(Bool, Bool), Never>!
      var isRefreshingObserver: TestObserver<Bool, Never>!
      var location: MutableProperty<String>!
      
      let lifecycle = ViewLifeCycle()
      let scheduler = TestScheduler()
      let refresh = MutableProperty<Void>(())
      
      beforeEach {
        Environment.current = .mock()
        Environment.current.scheduler = scheduler
        location = .init(Addresses[0])
        currentWeatherObserver = TestObserver()
        forecastObserver = TestObserver()
        isLoadingObserver = TestObserver()
        isRefreshingObserver = TestObserver()
        subject = ReactiveSwiftViewModel.create(input: .init(
          baseInput: .init(
            lifeCycle: lifecycle,
            refresh: refresh.signal
          ),
          locationProperty: location)
        )
        
        subject.currentWeather.observe(currentWeatherObserver.observer)
        subject.forecastDisplayData.observe(forecastObserver.observer)
        subject.dataLoading.observe(isLoadingObserver.observer)
        subject.isRefreshing.observe(isRefreshingObserver.observer)
      }
      
      it("Loads data") {
        lifecycle.viewDidLoad()
        scheduler.run()
        
        currentWeatherObserver.assertDidEmitValue()
        forecastObserver.assertDidEmitValue()
        isLoadingObserver.assertValueCount(2)
        isRefreshingObserver.assertDidNotEmitValue()
      }
      
      it("Refreshes data") {
        lifecycle.viewDidLoad()
        scheduler.run()
        
        refresh.value = ()
        scheduler.run()
        
        currentWeatherObserver.assertValueCount(2)
        forecastObserver.assertValueCount(2)
        isLoadingObserver.assertValueCount(2)
        isRefreshingObserver.assertValueCount(4)
      }
      
      it("Handles new data") {
        lifecycle.viewDidLoad()
        scheduler.run()
        
        location.value = Addresses[1]
        scheduler.run()
        
        currentWeatherObserver.assertValueCount(2)
        forecastObserver.assertValueCount(2)
        isLoadingObserver.assertValueCount(6)
      }
    }
  }
}
