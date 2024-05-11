//
//  WeatherStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct WeatherStore {
  var delegate: HostControllerDelegate?
  
  @Reducer(state: .equatable)
  enum Destination {
    case additionalWeather(ListWeatherStore)
  }
  
  @Dependency(\.weatherServiceCombine) var weatherService
  
  @ObservableState
  struct State: Equatable {
    var weatherState: ViewDataState<WeatherDisplayData> = .loading
    var selectedAddress: String = Addresses[0]
    @Presents var destination: Destination.State?
  }
  
  enum Action {
    case loadWeather
    case dataLoaded(WeatherDisplayData)
    case error
    case selectWeather(String)
    case showWeatherDetails
    case destination(PresentationAction<Destination.Action>)
    case hideContainerNav(Bool)
  }
  
  private enum CancelID {
    case loadWeather
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadWeather:
        let address = state.selectedAddress
        return .publisher {
          let loadCriteria = Environment.current.addressService.coordinatePublisher(address).compactMap{$0}.map(LoadCriteria.init)
          let currentWeather = loadCriteria.flatMap(weatherService.retrieveCurrentWeather)
          let forecast = loadCriteria.flatMap(weatherService.retrieveWeatherForecast)
          let combinedWeather = currentWeather.combineLatest(forecast)
            .receive(on: Environment.current.combineScheduler)
            .map { output in
              guard let currentWeather = output.0, let forecast = output.1 else { return WeatherStore.Action.error }
              let weather = WeatherDisplayData.init(currentWeather: currentWeather, forecast: forecast)
              return .dataLoaded(weather)
            }.catch { _ in
              return Just(WeatherStore.Action.error)
            }
          return combinedWeather
        }.cancellable(id: CancelID.loadWeather, cancelInFlight: true)
      case .dataLoaded(let data):
        state.weatherState = .dataLoaded(data)
        return .none
      case .error:
        state.weatherState = .error(nil)
        return .none
      case let .selectWeather(newWeather):
        state.weatherState = .loading
        if newWeather == state.selectedAddress { return .none }
        state.selectedAddress = newWeather
        return .send(.loadWeather)
      case .showWeatherDetails:
        state.destination = .additionalWeather(.init(location: state.selectedAddress))
        return .none
      case .hideContainerNav(let hide):
        delegate?.hideNavigation(hide: hide)
        return .none
      case .destination:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

}
