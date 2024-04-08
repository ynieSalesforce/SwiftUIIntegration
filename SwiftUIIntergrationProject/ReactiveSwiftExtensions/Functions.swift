//
//  Functions.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation

public func const<A, B>(_ a: A) -> (B) -> A {
    // swift_lint:disable opening_brace
  { _ in a }
}
