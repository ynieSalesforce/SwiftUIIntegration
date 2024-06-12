//
//  SectionedTabbarController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

class SectionedTabbarController: UIViewController {
  private lazy var tabBarStore: StoreOf<SectionTabStoreExample> = 
    .init(initialState: .init(
      tabState:
        .init(
          types: [TabSectionExample.first, TabSectionExample.second],
          selectedTab: .first) // Initial Selected Tab
    ), reducer: {
          SectionTabStoreExample()
        })
  private lazy var contentView: SectionTabViewExample = .init(store: tabBarStore)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let hosting = UIHostingController(rootView: contentView)
    view.addSubview(hosting.view)
    addChild(hosting)
    hosting.view.snp.updateConstraints { make in
      make.edges.equalTo(self.view)
    }
  }
}
