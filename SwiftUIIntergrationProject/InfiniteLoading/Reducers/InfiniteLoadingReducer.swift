//
//  InfiniteLoadingReducer.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/2/24.
//

import Foundation
import ComposableArchitecture
import Combine

@ObservableState
struct InfiniteLoadingState<Value: Identifiable & Equatable>: Equatable {
  var items: [Value] = []
  var pageInfo: PageInfo?
  var error: SimpleError?
  var isLoading: Bool = true
}

@CasePathable
enum InfiniteLoadingAction <Value: Identifiable & Equatable>{
  case loadInitialData
  case loadNextPage(PageInfo?)
  case dataLoaded(any Pageable<Value>)
  case nextPageLoaded(any Pageable<Value>)
  case error(SimpleError)
}

@Reducer
struct InfiniteLoadingReducer<Value: Identifiable & Equatable> {
  
  let loadData: (PageInfo?) -> DataPublisher<any Pageable<Value>>
  
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
            }.catch { error in
              return Just(InfiniteLoadingReducer.Action.error(error))
            }
        }.cancellable(id: CancelID.loadInfiniteData)
      case .dataLoaded(let displayData):
        state.isLoading = false
        state.items = displayData.items
        state.pageInfo = displayData.pageInfo
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
        state.items.append(contentsOf: displayData.items)
        state.pageInfo = displayData.pageInfo
        return .none
      }
    }
  }
}
