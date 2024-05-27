//
//  UIKitReactiveController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa
import SnapKit

class UIKitReactiveController: BaseViewController {
  fileprivate var forecastData: [ForecastList] = []
  fileprivate var headerData: CurrentWeatherDisplayData?
  private let locationProperty: MutableProperty<String> = .init(Addresses[0])
  
  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(headerFooterViewType: WeatherSectionHeader.self)
    tableView.register(cellType: WeatherForecastCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorInset = .zero
    
    tableView.sectionHeaderHeight = UITableView.automaticDimension
    tableView.rowHeight = UITableView.automaticDimension
    
    self.view.addSubview(tableView)
    tableView.refreshControl = refreshControl
    return tableView
  }()
  
  private lazy var weatherSelectionHeaderView: WeatherSelectorHeaderView = .init()
  
  override func configureUI() {
    tableView.snp.updateConstraints { make in
      make.edges.equalTo(self.view)
    }
    tableView.tableHeaderView = weatherSelectionHeaderView
    weatherSelectionHeaderView.configure(with: locationProperty)
    sizeHeaderToFit(tableView: tableView)
  }
  
  override func bindViewModel() {
    let output = ReactiveSwiftViewModel
      .create(
        input: .init(
          baseInput: .init(
            lifeCycle: lifecycle,
            refresh: refreshControl.refresh
          ), locationProperty: locationProperty)
      )
    
    reactive.currentWeatherData <~ output.currentWeather
    reactive.forecastData <~ output.forecastDisplayData
    refreshControl.reactive.isRefreshing <~ output.isRefreshing.observeForTableView()
    reactive.isLoading <~ output.dataLoading
  }
  
  func handleCurrentWeatherData(with currentWeather: CurrentWeatherDisplayData) {
    headerData = currentWeather
    tableView.reloadData()
  }
  
  func handleForecastWeatherData(with forecastData: ForecastDisplayData) {
    self.forecastData = forecastData.list
    tableView.reloadData()
  }
  
  func sizeHeaderToFit(tableView: UITableView) {
    if let headerView = tableView.tableHeaderView {
      let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
      var frame = headerView.frame
      frame.size.height = height
      headerView.frame = frame
      tableView.tableHeaderView = headerView
      headerView.setNeedsLayout()
      headerView.layoutIfNeeded()
    }
  }
}

extension UIKitReactiveController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerData = headerData else { return nil }
    let header = tableView.dequeueReusableHeaderFooterView(WeatherSectionHeader.self)
    header?.configure(with: headerData)
    return header
  }
}

extension UIKitReactiveController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    forecastData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: WeatherForecastCell.self)
    cell.configure(with: forecastData[indexPath.row])
    return cell
  }
}

private extension Reactive where Base: UIKitReactiveController {
  var currentWeatherData: BindingTarget<CurrentWeatherDisplayData> {
    makeBindingTarget { vc, data in
      vc.handleCurrentWeatherData(with: data)
    }
  }
  
  var forecastData: BindingTarget<ForecastDisplayData> {
    makeBindingTarget { vc, data in
      vc.handleForecastWeatherData(with: data)
    }
  }
  
  var isLoading: BindingTarget<(Bool, Bool)> {
    makeBindingTarget { vc, data in
      if !data.0, !data.1 {
        vc.loadingView.removeFromSuperview()
      } else {
        vc.addLoadingView()
      }
    }
  }
}
