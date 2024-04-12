//
//  UITableView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import UIKit

public extension UITableView {
  final func register<T: UITableViewCell>(cellType: T.Type)
  where T: Reusable {
    register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
  }
  
  final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
  where T: Reusable {
    guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
      fatalError()
    }
    return cell
  }
  
  final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
  where T: Reusable {
    register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
  }
  
  final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T?
  where T: Reusable {
    guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
      fatalError()
    }
    return view
  }
}
