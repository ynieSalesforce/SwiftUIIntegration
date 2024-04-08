//
//  Environment.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import ReactiveSwift

public struct Environment {
  var scheduler: DateScheduler = QueueScheduler(qos: .userInitiated, name: "com.salesforce.trailhead.userInitiated")
  var backgroundScheduler: DateScheduler = QueueScheduler(qos: .background, name: "com.salesforce.trailhead.background")
  var weatherServiceReactive: WeatherServiceReactive = .live
  var addressService: AddressService = .live
}

public extension Environment {
  static var current = Environment()
}
