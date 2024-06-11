//
//  SectionBAsedTabBarStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Foundation
import Combine
import ComposableArchitecture

@Reducer
struct SectionBasedTabBarStore <TabType: Identifiable & Equatable & Labeled>{
  
  @ObservableState
  struct State: Equatable {
    var types: [TabType]
    var selectedTab: TabType
    var tabIndex: Int = 0
  }
  
  @CasePathable
  enum Action {
    case selectTab(TabType)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .selectTab(let index):
        if let type = state.types.first(where: { $0 == index } ) {
          state.selectedTab = type
        }
        return .none
      }
    }
  }
}

protocol Labeled: TaggedIndex {
  var labelText: String { get }
}

protocol TaggedIndex: Hashable {
  var tagIndex: Int { get }
}
