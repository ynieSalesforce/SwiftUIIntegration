//
//  WeatherForecastCell.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import UIKit
import SnapKit

class WeatherForecastCell: UITableViewCell, Reusable {
  private lazy var temperatureLabel: UILabel = {
    let label = UILabel.init()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .darkText
    contentView.addSubview(label)
    return label
  }()
  
  func configure(with list: List) {
    temperatureLabel.text = "\(list.temperatures.temp)"
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    temperatureLabel.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview().offset(16)
      make.bottom.equalToSuperview().offset(-16)
    }
    super.updateConstraints()
  }
}
