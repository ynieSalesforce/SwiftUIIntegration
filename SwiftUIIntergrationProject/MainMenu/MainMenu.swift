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
    var desintation: Destination2?
    var item: String?
  }
  
  @Reducer(state: .equatable)
  enum Destination {
    case sampleNav(SampleNavigation)
  }
  
  @CasePathable
  @dynamicMemberLookup
  enum Destination2: Equatable {
    static func == (lhs: MainMenu.Destination2, rhs: MainMenu.Destination2) -> Bool {
      return true
    }
    
    case sampleNav(SampleNavigation)
  }
  
  enum Action {
    case path(StackActionOf<Path>)
    case loadSampleView(String)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .loadSampleView(input):
          // do one of the following
        state.path.append(.sampleNavDestination(.init(id: input)))
        state.destination = .sampleNav(.init(id: input))
        return .none
      default: return .none
      }
    }.forEach(\.path, action: \.path)
  }
}
