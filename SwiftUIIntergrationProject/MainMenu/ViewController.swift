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
  
    /// Creates a new store view controller with the given store.
    ///
    /// - Parameter store: The store to use with the view controller.
    ///
    /// - Returns: A new view controller.
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
      state.destination = .sampleNav(.init(id: input))
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

// Observed model
@Observable
class MainMenuModel {
  var mainMenu: StoreOf<MainMenu>
  var alert: String?
  var destination: MainMenu.Destination.State?
  var destinationUIKit: Destination?
  var cancellables: Set<AnyCancellable> = []
  
  init(menuState: MainMenu.State = .init(), alert: String? = nil) {
    self.mainMenu = .init(initialState: menuState) {
      MainMenu()
    }
    self.alert = alert
    setupBindings()
  }
  
  @CasePathable
  enum Destination {
    case sampleNav(String)
  }
  
  private func setupBindings() {
    
    mainMenu.publisher.destination.sink { _ in
      
    } receiveValue: { state in
      state.publisher.sink { _ in
        
      } receiveValue: { destination in
        self.destination = destination
      }.store(in: &self.cancellables)

    }.store(in: &cancellables)
  }
}

// Hosting View Controller
class MainMenuHostingController: StateStoreViewController<MainMenu.State, MainMenu.Action> {
  private lazy var menuView: UIHostingController<MainMenuView> = .init(rootView: .init(store: model))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
//
//    navigationDestination(item: $model.destination) { model in
//      switch model {
//      case .sampleNav(let state):
//        SampleNavigationController(model: .init(sampleNav: .init(initialState: state, reducer:  {
//          SampleNavigation()
//        })))
//      }
//    }
    
    navigationItem.title = "SwiftUI Demos"
  }
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    
//    let button = UIButton(type: .system, primaryAction: UIAction(title: "Update Alert", handler: { [weak self] _ in
//      self?.model.alert = "Test"
//    }))
//    button.setTitle("UIKit Button", for: .normal)
//    
//    view.addSubview(button)
//    button.snp.updateConstraints { make in
//      make.leading.trailing.equalTo(view)
//      make.centerY.equalTo(view)
//    }
//    
//    let button2 = UIButton(type: .system, primaryAction: UIAction(title: "Update Destination", handler: { [weak self] _ in
//      self?.model.destinationUIKit = .sampleNav("Input")
//    }))
//    button2.setTitle("Update Destination", for: .normal)
//    view.addSubview(button2)
//    button2.snp.updateConstraints { make in
//      make.leading.trailing.equalTo(view)
//      make.centerY.equalTo(view).offset(30)
//    }
//  }
}
