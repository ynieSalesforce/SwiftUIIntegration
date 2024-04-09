//
//  ViewDataState.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import Combine

enum ViewDataState<T> {
  case dataLoaded(T)
  case empty
  case loading
  case error(Error)
}

protocol LoadingViewData<Model>: ObservableObject {
  associatedtype Model
  var state: ViewDataState<Model> { get set }
  func retrieveData()
}
