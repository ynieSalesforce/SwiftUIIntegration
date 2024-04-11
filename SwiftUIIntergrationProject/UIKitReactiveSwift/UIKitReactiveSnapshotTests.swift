//
//  UIKitReactiveSnapshotTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/11/24.
//

import Foundation
import SnapshotTesting
import XCTest

@testable import SwiftUIIntergrationProject

final class UIKitReactiveSnapshotTests: XCTestCase {
  override func setUp() {
    super.setUp()
    isRecording = false
  }
  
  func testViewLoads() {
    Environment.current = .mock()
    let currentWeather = CurrentWeatherDisplayData.createMock()!
    let forecast = ForecastDisplayData.createMock()!
    
    let viewController = UIKitReactiveController()
    viewController.loadView()
    viewController.viewDidLoad()
    viewController.viewWillAppear(false)
  
    viewController.handleCurrentWeatherData(with: currentWeather)
    viewController.handleForecastWeatherData(with: forecast)
    viewController.loadingView.removeFromSuperview()
    
    assertSnapshot(matching: viewController, as: .image(on: .iPhone13Pro(.portrait)))
  }
}
