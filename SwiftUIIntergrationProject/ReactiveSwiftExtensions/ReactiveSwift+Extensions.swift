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

/*
 These types are generic alias for `materialized` SignalProducers that can send a stream
 of Events
 
 We use these to have a distinct output for data vs. errors so that if we encounter an error our data stream doesn't terminate
 and allows the user to try again.
 */
public typealias MaterializedSignalProducer<Value, Error: Swift.Error> = SignalProducer<SignalProducer<Value, Error>.ProducedSignal.Event, Never>
public typealias MaterializedDataLoadingProducer<Value> = MaterializedSignalProducer<Value, Error>

public typealias DataProducer<T> = SignalProducer<T, Error>
public typealias DataPublisher<T> = AnyPublisher<T, Never>
