//
//  InfiniteContentStore.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Combine

@Reducer
struct InfiniteContentStore {
  @Dependency(\.infiniteContentService) var contentService
  
  @ObservableState
  struct State: Equatable {
    var contentItems: ViewDataState<ContentDisplayModel> = .loading
  }
  
  enum Action {
    case loadInitialContent
    case loadNextPage(PageInfo)
    case dataLoaded(ContentDisplayModel)
    case nextPageDataLoaded(ContentDisplayModel)
    case error
  }
  
  private enum CancelID {
    case loadInfiniteData
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .loadInitialContent:
        return .publisher {
          contentService.retrieveContent(nil)
            .map {
              return .dataLoaded($0)
            }.catch { _ in
              return Just(InfiniteContentStore.Action.error)
            }
        }.cancellable(id: CancelID.loadInfiniteData, cancelInFlight: true)
      case .loadNextPage(let pageInfo):
        return .publisher {
          contentService.retrieveContent(pageInfo)
            .map {
              return .nextPageDataLoaded($0)
            }.catch { _ in
              return Just(InfiniteContentStore.Action.error)
            }
        }.cancellable(id: CancelID.loadInfiniteData, cancelInFlight: true)
      case .dataLoaded(let displayData):
        state.contentItems = .dataLoaded(displayData)
        return .none
      case .nextPageDataLoaded(let displayData):
        var currentContent = state.contentItems.data ?? .createMock(numberOfItems: 25)
        currentContent.items.append(contentsOf: displayData.items)
        currentContent.pageInfo = displayData.pageInfo
        state.contentItems = .dataLoaded(currentContent)
        return .none
      case .error:
        state.contentItems = .error(.address)
        return .none
      }
    }
  }
}
