//
//  InfiniteContentService.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Combine

struct InfiniteContentService {
  var retrieveContent: (PageInfo?) -> DataPublisher<ContentDisplayModel>
}

extension DependencyValues {
  var infiniteContentService: InfiniteContentService {
    get {
      self[InfiniteContentService.self]
    }
    set {
      self[InfiniteContentService.self] = newValue
    }
  }
}

extension InfiniteContentService: DependencyKey {
  static let liveValue = Self(
    retrieveContent: { info in
      Just(retrieveData(from: info)).setFailureType(to: SimpleError.self)
        .eraseToAnyPublisher()
    }
  )
  
  static let testValue: InfiniteContentService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self)
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  )
  
  static let previewValue: InfiniteContentService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self)
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
  )
}

private let pageSize: Int = 15

private func retrieveData(from pageInfo: PageInfo?) -> ContentDisplayModel {
  if let _ = pageInfo {
    return .createMock(numberOfItems: pageSize, pageInfo: nil)
  } else {
    return .createMock(numberOfItems: pageSize, pageInfo: .init(hasNextPage: true, endCursor: "test next page"))
  }
}
