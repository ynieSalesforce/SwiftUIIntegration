//
//  InfiniteLoadingReducer.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/2/24.
//

import Foundation
import ComposableArchitecture
import Combine

public struct PagingDisplayData<Value: Identifiable & Equatable & Hashable>: Equatable {
  var items: [Value]
  var pageInfo: PageInfo?
}

public struct PageInfo: Equatable, Codable {
  public let hasNextPage: Bool
  public let endCursor: String?
}

@ObservableState
struct InfiniteLoadingState<Value: Identifiable & Equatable & Hashable>: Equatable {
  var displayData: PagingDisplayData<Value>
  var error: SimpleError?
  var isLoading: Bool = true
}

@CasePathable
enum InfiniteLoadingAction <Value: Identifiable & Equatable & Hashable>{
  case loadInitialData
  case loadNextPage(PageInfo?)
  case dataLoaded(PagingDisplayData<Value>)
  case nextPageLoaded(PagingDisplayData<Value>)
  case error(SimpleError)
}

@Reducer
struct InfiniteLoadingReducer<Value: Identifiable & Equatable & Hashable> {
  
  let loadData: (PageInfo?) -> DataPublisher<PagingDisplayData<Value>>
  
  private enum CancelID {
    case loadInfiniteData
    case loadNextPageData
  }
  var body: some Reducer<InfiniteLoadingState<Value>, InfiniteLoadingAction<Value>> {
    Reduce { state, action in
      switch action {
      case .loadInitialData:
        return .publisher {
          loadData(nil)
            .map {
              return .dataLoaded($0)
            }
            .catch { error in
              return Just(InfiniteLoadingReducer.Action.error(error))
            }
        }.cancellable(id: CancelID.loadInfiniteData)
      case .dataLoaded(let displayData):
        state.isLoading = false
        state.displayData = displayData
        return .none
      case .error(let error):
        state.isLoading = false
        state.error = error
        return .none
      case .loadNextPage(let info):
        guard let info = info else {
          return .none
        }
        return .publisher {
          loadData(info)
            .map {
              return .nextPageLoaded($0)
            }.catch { error in
              // we need to handle a toast here
              return Just(InfiniteLoadingReducer.Action.error(error))
            }
        }
      case .nextPageLoaded(let displayData):
        var currentItems = state.displayData.items
        currentItems.append(contentsOf: displayData.items)
        let newDisplayData = PagingDisplayData.init(items: currentItems, pageInfo: displayData.pageInfo)
        state.displayData = newDisplayData
        return .none
      }
    }
  }
}
