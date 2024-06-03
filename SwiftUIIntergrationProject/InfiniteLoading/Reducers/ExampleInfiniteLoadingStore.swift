//
//  InfiniteLoadingStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/2/24.
//

import Foundation
import ComposableArchitecture
import Combine

@Reducer
struct ExampleInfiniteLoadingStore {
  @Dependency(\.infiniteContentService) var contentService
  
  @ObservableState
  struct State {
    var infiniteState: InfiniteLoadingState<ContentData>
  }
  
  enum Action {
    case infiniteAction(InfiniteLoadingAction<ContentData>)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.infiniteState, action: \.infiniteAction) {
      InfiniteLoadingReducer<ContentData>(loadData: contentService.retrieveContent)
    }
  }
}
