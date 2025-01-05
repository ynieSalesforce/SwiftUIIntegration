//
//  MainMenu.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/27/24.
//

import Foundation
import ComposableArchitecture
import SwiftNavigation

@Reducer
struct MainMenu {
  @Reducer(state: .equatable)
  enum Path {
    case sampleNavDestination(SampleNavigation)
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    
    @Presents var destination: Destination.State?
  }
  
  @Reducer(state: .equatable)
  enum Destination {
    case sampleNav(SampleNavigation)
  }
  
  enum Action {
    case path(StackActionOf<Path>)
    case loadSampleStackView(String)
    case loadSampleTreeView(String)
    case destination(PresentationAction<Destination.Action>)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .loadSampleStackView(input):
        state.path.append(.sampleNavDestination(.init(id: input)))
        return .none
      case let .path(.element(id: id, action: .sampleNavDestination(.tap))):
        state.path.pop(from: id)
        return .none
      case .loadSampleTreeView(let input):
        state.destination = .sampleNav(.init(id: input))
        return .none
      default: return .none
      }
    }.forEach(\.path, action: \.path)
      .ifLet(\.$destination, action: \.destination)
  }
}
