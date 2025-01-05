//
//  Environment.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import CombineSchedulers

public struct Environment {
  var combineScheduler: AnySchedulerOf<DispatchQueue> = .main
  var runLoop: RunLoop = .main
}

public extension Environment {
  static var current = Environment()
}
