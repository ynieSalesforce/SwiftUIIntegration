//
//  InfiniteLoadingController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI
import SnapKit
import ComposableArchitecture

class InfiniteLoadingController: UIViewController {
  private lazy var infiniteStore: StoreOf<InfiniteContentStore> = .init(initialState: .init()) {
    InfiniteContentStore()
  }
  private lazy var contentView: InfiniteContentView = .init(store: infiniteStore)
  
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
