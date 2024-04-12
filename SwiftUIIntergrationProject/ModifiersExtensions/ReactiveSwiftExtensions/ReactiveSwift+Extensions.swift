//
//  ReactiveSwift+Extensions.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/4/24.
//

import Foundation
import ReactiveSwift
import Combine

/*
 Helper to take a SignalProducer to be `switchMapped`, while also returning a Signal used to
 indicate when the work is being done in the given producer.
 */
func switchMapWithIndicator<V, E>(_ signal: Signal<SignalProducer<V, E>, Never>) -> (Signal<Bool, Never>, Signal<V, E>) {
  let indicator = MutableProperty<Bool>(false)
  let indicatingSignal = signal.flatMap(.latest) {
    $0.on(starting: { [weak indicator] in
      indicator?.value = true
    }, terminated: { [weak indicator] in
      indicator?.value = false
    }, value: { [weak indicator] _ in
      indicator?.value = false
    })
  }
  return (indicator.signal.skipRepeats(), indicatingSignal)
}

public extension Signal {
  /**
   Creates a new signal that emits a void value for every emission of `self`.
   
   - returns: A new signal.
   */
  func ignoreValues() -> Signal<Void, Error> {
    signal.map { _ in () }
  }
  
  /**
   Creates a new signal that removes errors from the stream and changes the error type to Never.
   
   - returns: A new signal.
   */
  func ignoreErrors() -> Signal<Value, Never> {
    signal.flatMapError { _ in
      SignalProducer<Value, Never>.empty
    }
  }
}

public extension SignalProducer {
  /**
   Creates a new producer that emits a void value for every emission of `self`.
   
   - returns: A new producer.
   */
  func ignoreValues() -> SignalProducer<Void, Error> {
    lift { $0.ignoreValues() }
  }
  
  /**
   Creates a new producer that removes errors from the stream and changes the error type to Never.
   
   - returns: A new producer.
   */
  func ignoreErrors() -> SignalProducer<Value, Never> {
    lift { $0.ignoreErrors() }
  }
}

public extension Signal where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of values of `Next` events from a materialized signal.
   */
  func values() -> Signal<Value.Value, Never> {
    signal.map { $0.event.value }.skipNil()
  }
}

public extension SignalProducer where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of values of `Next` events from a materialized signal.
   */
  func values() -> SignalProducer<Value.Value, Never> {
    lift { $0.values() }
  }
}

public extension Signal where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of errors of `Error` events from a materialized signal.
   */
  func errors() -> Signal<Value.Error, Never> {
    signal.map { $0.event.error }.skipNil()
  }
}

public extension SignalProducer where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of errors of `Error` events from a materialized signal.
   */
  func errors() -> SignalProducer<Value.Error, Never> {
    lift { $0.errors() }
  }
}

/*
 These types are generic alias for `materialized` SignalProducers that can send a stream
 of Events
 
 We use these to have a distinct output for data vs. errors so that if we encounter an error our data stream doesn't terminate
 and allows the user to try again.
 */
public typealias MaterializedSignalProducer<Value, Error: Swift.Error> = SignalProducer<SignalProducer<Value, Error>.ProducedSignal.Event, Never>
public typealias MaterializedDataLoadingProducer<Value> = MaterializedSignalProducer<Value, Error>

public typealias DataProducer<T> = SignalProducer<T, Error>
public typealias DataPublisher<T> = AnyPublisher<T, SimpleError>

public typealias TriggerSignal = Signal<Void, Never>
public typealias TriggerProducer = SignalProducer<Void, Never>

public typealias ValueSignal<T> = Signal<T, Error>
public typealias ValueSignalProducer<T> = SignalProducer<T, Never>
