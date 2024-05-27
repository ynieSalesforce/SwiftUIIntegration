//
//  InfiniteLoadingController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI
import SnapKit

class InfiniteLoadingController: UIViewController {
  private lazy var contentView: InfiniteContentView = .init()
  
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
