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
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel.init()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .darkText
    contentView.addSubview(label)
    return label
  }()
  
  private lazy var weatherLabel: UILabel = {
    let label = UILabel.init()
    label.font = .systemFont(ofSize: 14)
    label.textColor = .darkText
    contentView.addSubview(label)
    return label
  }()
  
  func configure(with list: List) {
    timeLabel.text = list.displayDate
    temperatureLabel.text = "Temperature: \(list.temperatures.temp.formattedRoundedWholeNumber())F"
    weatherLabel.text = list.weather.first?.description
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    timeLabel.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalToSuperview().offset(16)
    }
    
    weatherLabel.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalTo(timeLabel.snp.bottom).offset(10)
    }
    
    temperatureLabel.snp.updateConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.top.equalTo(weatherLabel.snp.bottom).offset(10)
      make.bottom.equalToSuperview().offset(-16)
    }
    super.updateConstraints()
  }
}
