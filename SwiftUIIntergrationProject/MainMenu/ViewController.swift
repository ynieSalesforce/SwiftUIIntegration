//
//  ViewController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/2/24.
//

import UIKit
import SwiftUI
import SnapKit

class ViewController: UIViewController {
  private lazy var menuView: UIHostingController<MainMenuView> = .init(rootView: .init(delegate: self))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
    navigationItem.title = "SwiftUI Demos"
  }
}

extension ViewController: MainMenuViewDelegate {
  func navigate(to destination: DemoType) {
    handle(action: destination)
  }
}
