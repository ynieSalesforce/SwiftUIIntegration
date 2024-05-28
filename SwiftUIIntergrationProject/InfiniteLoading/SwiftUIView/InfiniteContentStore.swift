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
  @Dependency(\.continuousClock) var clock
  
  @ObservableState
  struct State: Equatable {
    var contentItems: ViewDataState<ContentDisplayModel> = .loading
    var displayItems: ContentDisplayModel = .init(items: [])
  }
  
  enum Action {
    case loadInitialContent
    case loadNextPage(PageInfo?)
    case dataLoaded(ContentDisplayModel)
    case delayNextPageLoaded(ContentDisplayModel)
    case nextPageDataLoaded(ContentDisplayModel)
    case error
  }
  
  private enum CancelID {
    case loadInfiniteData
    case loadNextPageData
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
        guard let pageInfo = pageInfo else { return .none }
        return .publisher {
          contentService.retrieveContent(pageInfo)
            .map {
              return .delayNextPageLoaded($0)
            }.catch { _ in
              return Just(InfiniteContentStore.Action.error)
            }
        }.cancellable(id: CancelID.loadNextPageData, cancelInFlight: true)
      case .dataLoaded(let displayData):
        state.contentItems = .dataLoaded(displayData)
        return .none
      case .delayNextPageLoaded(let displayData): // Adds delay so we can see progress
        return .run { send in
          try await self.clock.sleep(for: .seconds(2))
          await send(.nextPageDataLoaded(displayData))
        }
        .cancellable(id: CancelID.loadNextPageData)
      case .nextPageDataLoaded(let displayData):
        guard var currentContent = state.contentItems.data else {
          return .run { send in
            await send(.dataLoaded(displayData))
          }.cancellable(id: CancelID.loadInfiniteData)
        }
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
