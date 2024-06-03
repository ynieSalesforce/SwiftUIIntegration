//
//  InfiniteLoadingStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/2/24.
//

import Foundation
import ComposableArchitecture
import Combine

struct ContentDisplayModel: Pageable, Equatable {
  typealias Value = ContentData
  var pageInfo: PageInfo?
  var items: [ContentData]
}

struct ContentData: Identifiable, Hashable, Equatable {
  let id: String
  let label: String
  let content: String
}

@Reducer
struct ExampleInfiniteLoadingStore {
  @Dependency(\.infinitePagingDisplayDataService) var contentService
  
  @ObservableState
  struct State {
    var infiniteState: InfiniteLoadingState<ContentData>
    var content: [ContentData]
  }
  
  enum Action {
    case infiniteAction(InfiniteLoadingAction<ContentData>)
    case loadData(any Pageable<ContentData>)
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.infiniteState, action: \.infiniteAction) {
      InfiniteLoadingReducer<ContentData>(loadData: contentService.retrieveContent)
    }
  }
}
