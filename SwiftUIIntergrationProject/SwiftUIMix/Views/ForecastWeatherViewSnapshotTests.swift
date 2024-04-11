//
//  ForecastWeatherViewSnapshotTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/11/24.
//

import Foundation
import PreviewSnapshotsTesting
import XCTest

@testable import SwiftUIIntergrationProject

final class ForecastWeatherViewSnapshotTests: XCTestCase {
  func test_snapshots() {
    ForecastWeatherView_Previews.snapshots.assertSnapshots(
      as: [
        .image(
          layout: .device(config: .iPhone13)
        ),
      ],
      record: false
    )
  }
}
