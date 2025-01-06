//
//  ViewController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/2/24.
//

import UIKit
import SwiftUI
import SnapKit
import ComposableArchitecture
import UIKitNavigation
import SwiftNavigation
import Combine

open class StateStoreViewController<State: Equatable, Action>: UIViewController {
  
    // MARK: Properties
  
    /// The store powering the view controller.
  @UIBindable open var model: Store<State, Action>
  
    /// Keeps track of subscriptions.
  open var cancellables: Set<AnyCancellable> = []
  
    // MARK: Initialization
  public init(store: Store<State, Action>) {
    self.model = store
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable) public required init?(coder: NSCoder) {
    fatalError("Not implemented")
  }
  
}

var appReducer: some Reducer<MainMenu.State, MainMenu.Action> {
  Reduce { state, action in
    switch action {
    case let .loadSampleStackView(input):
      state.path.append(.sampleNavDestination(.init(id: input)))
      return .none
    case let .path(.element(id: id, action: .sampleNavDestination(.tap))):
      state.path.pop(from: id)
      return .none
    case .loadSampleTreeView(let input):
      // state.destination = .sampleNav(.init(id: input))
      return .none
    default: return .none
    }
  }.forEach(\.path, action: \.path)
    .ifLet(\.$destination, action: \.destination)
}

struct MainMenuView: View {
  @Bindable var store: StoreOf<MainMenu>
  
  var body: some View {
    NavigationStack (
      path: $store.scope(state: \.path, action: \.path)
    ) {
        VStack(spacing: 20) {
          Button (action: {
            store.send(.loadSampleStackView("test1"))
          }, label: {
            Text("Navigate to Sample Stack View")
          }).padding(.top, 20)
          
          Button (action: {
            store.send(.loadSampleTreeView("test2"))
          }, label: {
            Text("Navigate to Sample Tree View")
          }).padding(.top, 20)
          
          Spacer()
        }
        .navigationDestination(
          item: $store.scope(
            state: \.destination?.sampleNav,
            action: \.destination.sampleNav)) { store in
              SampleNavigationView(store: store)
            }
    } destination: { store in
      switch store.case {
      case .sampleNavDestination(let store):
        SampleNavigationView(store: store)
      }
    }
  }
}

@Observable
class MainMenuModel {
  var destination: String?
}

// Hosting View Controller
class MainMenuHostingController: StateStoreViewController<MainMenu.State, MainMenu.Action> {
  @UIBinding var observedModel: MainMenuModel = .init()
  
  private var combinedReducer: some Reducer<MainMenu.State, MainMenu.Action> {
    CombineReducers {
      appReducer
      
      Reduce { [weak self] state, action in
        switch action {
        case let .loadSampleTreeView(input):
          self?.observedModel.destination = input
          return .none
        default: return .none
        }
      }
    }
  }
  private lazy var menuView: UIHostingController<MainMenuView> = .init(rootView: .init(store: .init(initialState: MainMenu.State(), reducer: {
    combinedReducer
  })))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
    navigationDestination(item: $observedModel.destination) { input in
      SampleNavigationController(model: .init(sampleNav: .init(initialState: SampleNavigation.State(id: input), reducer: {
        SampleNavigation()
      })))
    }
    navigationItem.title = "SwiftUI Demos"
  }
}
