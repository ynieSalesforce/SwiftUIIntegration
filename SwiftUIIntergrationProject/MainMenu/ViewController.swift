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

// Observed model
@Observable
class MainMenuModel {
  var menuState: MainMenu.State
  var mainMenu: StoreOf<MainMenu>
  var alert: String?

  init(menuState: MainMenu.State = .init(), alert: String? = nil) {
    self.menuState = menuState
    self.mainMenu = .init(initialState: menuState) {
      MainMenu()
    }
    self.alert = alert
  }
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
        }.navigationDestination(
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

// View Controller
class ViewController: UIViewController {
  @UIBindable var model: MainMenuModel = .init()

  private lazy var menuView: UIHostingController<MainMenuView> = .init(rootView: .init(store: model.mainMenu))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
//    present(item: $model.mainMenu.desintation) { sampleNav in
//      let model = SampleNavigationModel(sampleNav: sampleNav)
//      let vc = SampleNavigationController(model: model)
//      return vc
//    }
    
    navigationItem.title = "SwiftUI Demos"
  }
}
