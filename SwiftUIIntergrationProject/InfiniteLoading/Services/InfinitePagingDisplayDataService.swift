//
//  InfinitePagingDisplayDataService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/3/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Combine

struct InfinitePagingDisplayDataService {
  var retrieveContent: (PageInfo?) -> DataPublisher<PagingDisplayData<ContentData>>
}

extension DependencyValues {
  var infinitePagingDisplayDataService: InfinitePagingDisplayDataService {
    get {
      self[InfinitePagingDisplayDataService.self]
    }
    set {
      self[InfinitePagingDisplayDataService.self] = newValue
    }
  }
}

extension InfinitePagingDisplayDataService: DependencyKey {
  static let liveValue = Self(
    retrieveContent: { info in
      Just(retrieveData(from: info)).setFailureType(to: SimpleError.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let testValue: InfinitePagingDisplayDataService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self)
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  )
  
  static let previewValue: InfinitePagingDisplayDataService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self)
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  )
}

private let pageSize: Int = 15

private func retrieveData(from pageInfo: PageInfo?) -> PagingDisplayData<ContentData> {
  if let _ = pageInfo {
    let contentModel = ContentDisplayModel.createMock(numberOfItems: pageSize, pageInfo: nil)
    return .init(items: contentModel.items, pageInfo: contentModel.pageInfo)
  } else {
    let contentModel = ContentDisplayModel.createMock(numberOfItems: pageSize, pageInfo: .init(hasNextPage: true, endCursor: "test next page"))
    return .init(items: contentModel.items, pageInfo: contentModel.pageInfo)
  }
}
