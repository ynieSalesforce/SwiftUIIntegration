//
//  ListWeatherStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/15/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct ListWeatherStore {
  @Dependency(\.weatherServiceCombine) var weatherService
  
  @ObservableState
  struct State: Equatable {
    var location: String
    var weather: ViewDataState<WeatherDisplayData> = .loading
  }
  
  enum Action {
    case loadData
    case dataLoaded(WeatherDisplayData)
    case error(SimpleError)
  }
  
  private enum CancelID {
    case loadWeather
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadData:
        let location = state.location
        return .publisher {
          let loadCriteria = Environment.current.addressService.coordinatePublisher(location).compactMap{$0}.map(LoadCriteria.init)
          let currentWeather = loadCriteria.flatMap(weatherService.retrieveCurrentWeather)
          let forecast = loadCriteria.flatMap(weatherService.retrieveWeatherForecast)
          let combinedWeather = currentWeather.combineLatest(forecast)
            .receive(on: Environment.current.combineScheduler)
            .map { output in
              guard let currentWeather = output.0, let forecast = output.1 else {
                return ListWeatherStore.Action.error(.dataParse(nil))
              }
              let weather = WeatherDisplayData.init(currentWeather: currentWeather, forecast: forecast)
              return .dataLoaded(weather)
            }.catch { error in
              return Just(ListWeatherStore.Action.error(.dataLoad(error.localizedDescription)))
            }
          return combinedWeather
        }.cancellable(id: CancelID.loadWeather, cancelInFlight: true)
      case .dataLoaded(let data):
        state.weather = .dataLoaded(data)
        return .none
      case .error(let error):
        state.weather = .error(error)
        return .none
      }
    }
  }
}
