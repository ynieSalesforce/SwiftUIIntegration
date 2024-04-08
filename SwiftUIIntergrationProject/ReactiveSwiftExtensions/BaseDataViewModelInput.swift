//
//  BaseDataViewModelInput.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import ReactiveSwift

struct BaseDataViewModelInput {
  let lifeCycle: ViewLifeCycle
  let refresh: TriggerSignal
}

