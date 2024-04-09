//
//  WeatherSectionHeader.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import UIKit
import SnapKit

class WeatherSectionHeader: UITableViewHeaderFooterView, Reusable {
  private lazy var cityLabel: UILabel = {
    let label = UILabel.init()
    label.textColor = .darkText
    label.font = .boldSystemFont(ofSize: 18)
    contentView.addSubview(label)
    return label
  }()
  
  func configure(with currentWeather: CurrentWeatherDisplayData) {
    cityLabel.text = currentWeather.name
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    cityLabel.snp.updateConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(10)
      make.bottom.equalToSuperview().offset(-10)
    }
    super.updateConstraints()
  }
}
