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
  var retrieveContent: (PageInfo?) -> DataPublisher<ContentModel>
}

extension DependencyValues {
  var infiniteContentService: WeatherServiceCombine {
    get {
      self[WeatherServiceCombine.self]
    }
    set {
      self[WeatherServiceCombine.self] = newValue
    }
  }
}

extension InfiniteContentService: DependencyKey {
  static let liveValue = Self(
    retrieveContent: { info in
      Just(retrieveData(from: info)).setFailureType(to: SimpleError.self).eraseToAnyPublisher()
    }
  )
  
  static let testValue: InfiniteContentService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self).eraseToAnyPublisher()
    }
  )
  
  static let previewValue: InfiniteContentService = Self(
    retrieveContent: {
      Just(retrieveData(from: $0)).setFailureType(to: SimpleError.self).eraseToAnyPublisher()
    }
  )
}

private func retrieveData(from pageInfo: PageInfo?) -> ContentModel {
  if let _ = pageInfo {
    return .createMock(numberOfItems: 25, pageInfo: nil)
  } else {
    return .createMock(numberOfItems: 25, pageInfo: .init(hasNextPage: true, endCursor: "test next page"))
  }
}
