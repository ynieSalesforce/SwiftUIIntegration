//
//  TestObserver.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import ReactiveSwift
import XCTest

@testable import SwiftUIIntergrationProject

internal final class TestObserver<Value, Error: Swift.Error> {
  internal private(set) var events: [Signal<Value, Error>.Event] = []
  internal private(set) var observer: Signal<Value, Error>.Observer!
  
  internal init() {
    observer = Signal<Value, Error>.Observer(action)
  }
  
  private func action(_ event: Signal<Value, Error>.Event) {
    events.append(event)
  }
  
    /// Get all of the next values emitted by the signal.
  internal var values: [Value] {
    events.filter { $0.isValue }.map { $0.value! }
  }
  
    /// Get the last value emitted by the signal.
  internal var lastValue: Value? {
    values.last
  }
  
    /// `true` if at least one `.Next` value has been emitted.
  internal var didEmitValue: Bool {
    !values.isEmpty
  }
  
    /// The failed error if the signal has failed.
  internal var failedError: Error? {
    events.filter { $0.isFailed }.map { $0.error! }.first
  }
  
    /// `true` if a `.Failed` event has been emitted.
  internal var didFail: Bool {
    failedError != nil
  }
  
    /// `true` if a `.Completed` event has been emitted.
  internal var didComplete: Bool {
    !events.filter { $0.isCompleted }.isEmpty
  }
  
    /// `true` if a .Interrupt` event has been emitted.
  internal var didInterrupt: Bool {
    !events.filter { $0.isInterrupted }.isEmpty
  }
  
  internal func assertDidComplete(
    _ message: String = "Should have completed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(didComplete, message, file: file, line: line)
  }
  
  internal func assertDidFail(
    _ message: String = "Should have failed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(didFail, message, file: file, line: line)
  }
  
  internal func assertDidNotFail(
    _ message: String = "Should not have failed.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(didFail, message, file: file, line: line)
  }
  
  internal func assertDidInterrupt(
    _ message: String = "Should have interrupted.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(didInterrupt, message, file: file, line: line)
  }
  
  internal func assertDidNotInterrupt(
    _ message: String = "Should not have interrupted.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(didInterrupt, message, file: file, line: line)
  }
  
  internal func assertDidNotComplete(
    _ message: String = "Should not have completed",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertFalse(didComplete, message, file: file, line: line)
  }
  
  internal func assertDidEmitValue(
    _ message: String = "Should have emitted at least one value.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssert(!values.isEmpty, message, file: file, line: line)
  }
  
  internal func assertDidNotEmitValue(
    _ message: String = "Should not have emitted any values.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(0, values.count, message, file: file, line: line)
  }
  
  internal func assertDidTerminate(
    _ message: String = "Should have terminated, i.e. completed/failed/interrupted.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(didFail || didComplete || didInterrupt, message, file: file, line: line)
  }
  
  internal func assertDidNotTerminate(
    _ message: String = "Should not have terminated, i.e. completed/failed/interrupted.",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertTrue(!didFail && !didComplete && !didInterrupt, message, file: file, line: line)
  }
  
  internal func assertValueCount(
    _ count: Int,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      count,
      values.count,
      message ?? "Should have emitted \(count) values",
      file: file,
      line: line
    )
  }
}

extension TestObserver where Value: Equatable {
  internal func assertValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(1, values.count, "A single item should have been emitted.", file: file, line: line)
    XCTAssertEqual(
      value,
      lastValue,
      message ?? "A single value of \(value) should have been emitted",
      file: file,
      line: line
    )
  }
  
  internal func assertLastValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      value,
      lastValue,
      message ?? "Last emitted value is equal to \(value).",
      file: file,
      line: line
    )
  }
  
  internal func assertValues(
    _ values: [Value],
    _ message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(values, self.values, message, file: file, line: line)
  }
}

extension TestObserver where Value: ReactiveSwift.OptionalProtocol, Value.Wrapped: Equatable {
  internal func assertValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(1, values.count, "A single item should have been emitted.", file: file, line: line)
    XCTAssertEqual(
      value.optional,
      lastValue?.optional,
      message ?? "A single value of \(value) should have been emitted",
      file: file,
      line: line
    )
  }
  
  internal func assertLastValue(
    _ value: Value,
    _ message: String? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(
      value.optional,
      lastValue?.optional,
      message ?? "Last emitted value is equal to \(value).",
      file: file,
      line: line
    )
  }
  
//  internal func assertValues(
//    _ values: [Value],
//    _ message: String = "",
//    file: StaticString = #file,
//    line: UInt = #line
//  ) {
//    XCTAssertEqual(values, self.values, message, file: file, line: line)
//  }
}

extension TestObserver where Error: Equatable {
  internal func assertFailed(
    _ expectedError: Error,
    message: String = "",
    file: StaticString = #file,
    line: UInt = #line
  ) {
    XCTAssertEqual(expectedError, failedError, message, file: file, line: line)
  }
}

internal extension Signal.Event {
  var isValue: Bool {
    if case .value = self {
      return true
    }
    return false
  }
  
  var isFailed: Bool {
    if case .failed = self {
      return true
    }
    return false
  }
  
  var isInterrupted: Bool {
    if case .interrupted = self {
      return true
    }
    return false
  }
}
