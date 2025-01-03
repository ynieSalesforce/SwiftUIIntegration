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
  //var destination: MainMenu.Destination2?

  
  init(menuState: MainMenu.State = .init(), alert: String? = nil) {
    self.menuState = menuState
    self.mainMenu = .init(initialState: menuState) {
      MainMenu()
    }
    self.alert = alert
  }
}

// View Controller
class ViewController: UIViewController {
  @UIBindable var model: MainMenuModel = .init()

  private lazy var menuView: UIHostingController<MainMenuView> = .init(rootView: .init(delegate: self, store: model.mainMenu))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
    present(item: $model.mainMenu.desintation) { sampleNav in
      let model = SampleNavigationModel(sampleNav: sampleNav)
      let vc = SampleNavigationController(model: model)
      return vc
    }
    
    navigationItem.title = "SwiftUI Demos"
  }
}

extension ViewController: MainMenuViewDelegate {
  func navigate(to destination: DemoType) {
    handle(action: destination)
  }
}
