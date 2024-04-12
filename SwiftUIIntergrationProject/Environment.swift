//
//  Environment.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import ReactiveSwift
import CombineSchedulers

public struct Environment {
  var scheduler: ReactiveSwift.Scheduler = QueueScheduler(qos: .userInitiated, name: "com.salesforce.trailhead.userInitiated")
  var combineScheduler: AnySchedulerOf<DispatchQueue> = .main
  var backgroundScheduler: DateScheduler = QueueScheduler(qos: .background, name: "com.salesforce.trailhead.background")
  var runLoop: RunLoop = .main
  var weatherServiceReactive: WeatherServiceReactive = .live
  var addressService: AddressService = .live
}

public extension Environment {
  static var current = Environment()
}
