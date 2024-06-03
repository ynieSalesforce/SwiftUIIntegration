//
//  HigherOrderReducer.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/1/24.
//

import Foundation
import ComposableArchitecture

  // 1
@Reducer
struct UppercasedReducer<State, Action, UppercaseAction> where Action: CasePathable {
    // 2
  private let keyPathToText: KeyPath<State, String>
  private let keyPathToUppercasedText: WritableKeyPath<State, String>
  private let caseKeyPathToAction: CaseKeyPath<Action, UppercaseAction>
  
  init(
    input keyPathToText: KeyPath<State, String>,
    output keyPathToUppercasedText: WritableKeyPath<State, String>,
    triggerAction caseKeyPathToAction: CaseKeyPath<Action, UppercaseAction>
  ) {
    self.keyPathToText = keyPathToText
    self.keyPathToUppercasedText = keyPathToUppercasedText
    self.caseKeyPathToAction = caseKeyPathToAction
  }
  
    // 3
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    if action[case: caseKeyPathToAction] != nil {
      state[keyPath: keyPathToUppercasedText] = state[keyPath: keyPathToText].uppercased()
    }
    return .none
  }
}

@Reducer
struct ShoutingText {
  @ObservableState
  
  struct State {
    var text: String = ""
    var uppercasedText = ""
  }
  
  @CasePathable
  enum Action: BindableAction {
    case didTapShoutButton
    case binding(BindingAction<State>)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    UppercasedReducer(
      input: \.text,
      output: \.uppercasedText,
      triggerAction: \.didTapShoutButton
    )
  }
}
