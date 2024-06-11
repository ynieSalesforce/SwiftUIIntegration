//
//  SectionTabStoreExample.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Foundation
import ComposableArchitecture

enum TabSectionExample {
  case first
  case second
}

extension TabSectionExample: Identifiable, Equatable, Labeled {
  var id: Self {
    self
  }
  
  var labelText: String {
    switch self {
    case .first:
      "First View"
    case .second:
      "Second View"
    }
  }
  
  var tagIndex: Int {
    switch self {
    case .first:
      return 0
    case .second:
      return 1
    }
  }
  
  
}

@Reducer
struct SectionTabStoreExample {
  
  @ObservableState 
  struct State: Equatable {
    var tabState: SectionBasedTabBarStore<TabSectionExample>.State
    var randomText: String = "Example Text"
  }
  
  enum Action {
    case tabBarAction(SectionBasedTabBarStore<TabSectionExample>.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.tabState, action: \.tabBarAction) {
      SectionBasedTabBarStore()
    }
  }
}
