//
//  ViewDataState.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import Combine

enum ViewDataState<T>: Equatable where T: Equatable {
  case dataLoaded(T)
  case empty
  case loading
  case error(SimpleError?)
}

protocol LoadingViewData<Model>: ObservableObject where Model: Equatable {
  associatedtype Model
  var state: ViewDataState<Model> { get set }
  func retrieveData()
}
