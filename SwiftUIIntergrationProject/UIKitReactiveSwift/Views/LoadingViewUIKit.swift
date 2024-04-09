//
//  LoadingViewUIKit.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import UIKit
import SnapKit

class LoadingViewUIKit: UIView {
  private lazy var progressView: UIActivityIndicatorView = .init(style: .large)
  
  init() {
    super.init(frame: .zero)
    addSubview(progressView)
    progressView.snp.updateConstraints { make in
      make.center.equalToSuperview()
    }
    progressView.startAnimating()
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    nil
  }
}
