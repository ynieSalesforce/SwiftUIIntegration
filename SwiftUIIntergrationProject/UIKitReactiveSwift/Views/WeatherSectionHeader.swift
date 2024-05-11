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
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel.init()
    label.textColor = .darkText
    label.font = .systemFont(ofSize: 15)
    contentView.addSubview(label)
    return label
  }()
  
  private lazy var temperatureLabel: UILabel = {
    let label = UILabel.init()
    label.textColor = .darkText
    label.font = .systemFont(ofSize: 15)
    contentView.addSubview(label)
    return label
  }()
  
  func configure(with currentWeather: CurrentWeatherDisplayData) {
    cityLabel.text = currentWeather.name
    descriptionLabel.text = currentWeather.weather.first?.description
    temperatureLabel.text = "Current temperature: \(currentWeather.main.temp.formattedRoundedWholeNumber()) F"
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  override func updateConstraints() {
    cityLabel.snp.updateConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(10)
    }
    
    descriptionLabel.snp.updateConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(cityLabel.snp.bottom).offset(10)
    }
    
    temperatureLabel.snp.updateConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
      make.bottom.equalToSuperview().inset(10)
    }
    super.updateConstraints()
  }
}
