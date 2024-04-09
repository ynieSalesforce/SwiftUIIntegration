//
//  WeatherSelectorHeaderView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

class WeatherSelectorHeaderView: UIView {
  private lazy var addressButton1: UIButton = {
    let button = UIButton(configuration: .tinted(), primaryAction: nil)
    button.setTitle("Address 1", for: .normal)
    addSubview(button)
    return button
  }()
  
  private lazy var addressButton2: UIButton = {
    let button = UIButton(configuration: .tinted(), primaryAction: nil)
    button.setTitle("Address 2", for: .normal)
    addSubview(button)
    return button
  }()
  
  private lazy var addressButton3: UIButton = {
    let button = UIButton(configuration: .tinted(), primaryAction: nil)
    button.setTitle("Address 3", for: .normal)
    addSubview(button)
    return button
  }()
  
  func configure(with property: MutableProperty<String>) {
    addressButton1.onTap {
      property.value = Addresses[0]
    }
    
    addressButton2.onTap {
      property.value = Addresses[1]
    }
    
    addressButton3.onTap {
      property.value = Addresses[2]
    }
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    addressButton1.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    
    addressButton2.snp.updateConstraints { make in
      make.leading.equalTo(addressButton1.snp.trailing).offset(10)
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    
    addressButton3.snp.updateConstraints { make in
      make.leading.equalTo(addressButton2.snp.trailing).offset(10)
      make.trailing.equalToSuperview().inset(10)
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    super.updateConstraints()
  }
}

extension UIControl {
  func onTap(_ action: (() -> Void)?) {
    reactive.controlEvents(.touchUpInside).take(during: reactive.lifetime)
      .observeValues { _ in
        action?()
      }
  }
  
  func onValueChanged(_ action: (() -> Void)?) {
    reactive.controlEvents(.valueChanged).take(during: reactive.lifetime)
      .observeValues { _ in
        action?()
      }
  }
}
