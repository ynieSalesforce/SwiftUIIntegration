//
//  ReactiveSwiftViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import Overture
import ReactiveSwift
import MapKit

struct ReactiveSwiftViewModel {
  struct Input {
    let baseInput: BaseDataViewModelInput
    let locationProperty: MutableProperty<String>
  }
  
  struct Output {
    let currentWeather: Signal<CurrentWeatherDisplayData, Never>
    let forecastDisplayData: Signal<ForecastDisplayData, Never>
    var dataLoading: Signal<(Bool, Bool), Never>
    var isRefreshing: Signal<Bool, Never>
    let dataLoadError: Signal<Error, Never>
  }
  
  static func create(input: ReactiveSwiftViewModel.Input) -> ReactiveSwiftViewModel.Output {
    let scheduler = Environment.current.scheduler
    let onLoad = input.baseInput.lifeCycle.viewDidLoadProperty.signal.observe(on: scheduler)
    let onRefresh = input.baseInput.refresh.observe(on: scheduler)
    
    let load = onLoad.flatMap(.latest) { _ in
      coordinates(from: input.locationProperty.value).skipNil().map(LoadCriteria.init)
    }.ignoreErrors()
    
    let loadDifferentLocation = input.locationProperty.signal.flatMap(.latest) { location in
      coordinates(from: location).skipNil().map(LoadCriteria.init)
    }.ignoreErrors()
    
    let refresh = onRefresh.flatMap(.latest) { _ in
      coordinates(from: input.locationProperty.value).skipNil().map(LoadCriteria.init)
    }.ignoreErrors()
    
    let (isLoadingCurrent, currentOnLoad) = switchMapWithIndicator(
      load.merge(with: loadDifferentLocation).map(currentWeather)
    )
    let (isLoadingForecast, forecastOnLoad) = switchMapWithIndicator(
      load.merge(with: loadDifferentLocation).map(weatherForecast)
    )
    
    let (isRefreshingCurrent, currentRefresh) = switchMapWithIndicator(refresh.map(currentWeather))
    let (isRefreshingForecast, forecastRefresh) = switchMapWithIndicator(refresh.map(weatherForecast))
    
    let currentWeatherData = Signal.merge(currentOnLoad, currentRefresh)
    let forecastWeatherData = Signal.merge(forecastOnLoad, forecastRefresh)
    
    let dataLoading = Signal.combineLatest(isLoadingCurrent, isLoadingForecast)
    let dataRefreshing = Signal.merge(isRefreshingCurrent, isRefreshingForecast)
    
    return .init(
      currentWeather: currentWeatherData.values(), 
      forecastDisplayData: forecastWeatherData.values(),
      dataLoading: dataLoading,
      isRefreshing: dataRefreshing,
      dataLoadError: currentWeatherData.errors())
  }
}

private func coordinates(from address: String) -> ValueSignalProducer<CLLocation?> {
  Environment.current.addressService.coordinates(address)
}

private func currentWeather(from loadCriteria: LoadCriteria) -> MaterializedDataLoadingProducer<CurrentWeatherDisplayData> {
  Environment.current.weatherServiceReactive.retrieveCurrentWeather(loadCriteria).materialize()
}

private func weatherForecast(from loadCriteria: LoadCriteria) -> MaterializedDataLoadingProducer<ForecastDisplayData> {
  Environment.current.weatherServiceReactive.retrieveWeatherForecast(loadCriteria).materialize()
}
