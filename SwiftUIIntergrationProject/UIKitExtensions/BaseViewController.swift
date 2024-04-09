//
//  BaseViewController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/8/24.
//

import Foundation
import ReactiveSwift
import UIKit
import Overture
import SnapKit

/**
 BaseViewController is the base class for all view controllers
 which handles common task during ViewController lifecycle
 */

class BaseViewController: UIViewController {
  lazy var refreshControl = RefreshControl()
  let lifecycle = ViewLifeCycle()
  lazy var loadingView: LoadingViewUIKit = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindViewModel()
    
    lifecycle.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
    view.addSubview(loadingView)
    loadingView.snp.updateConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    lifecycle.viewDidAppear()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    lifecycle.viewDidDisappear()
  }
  
  // child class to override to setup UI
  func configureUI() {
      // do nothing
  }
  
  // child class to override to bind to view model
  func bindViewModel() {
      // do nothing
  }
}

internal struct ViewLifeCycle {
  let isVisible: Property<Bool>
  
  init() {
    isVisible = Property(initial: false, then: Signal.merge(
      viewDidAppearProperty.signal.map(const(true)),
      viewDidDisappearProperty.signal.map(const(false))
    ).skipRepeats())
  }
  
  let viewDidLoadProperty = MutableProperty(())
  public func viewDidLoad() {
    viewDidLoadProperty.value = ()
  }
  
  let viewDidAppearProperty = MutableProperty(())
  public func viewDidAppear() {
    viewDidAppearProperty.value = ()
  }
  
  let viewDidDisappearProperty = MutableProperty(())
  public func viewDidDisappear() {
    viewDidDisappearProperty.value = ()
  }
}

final class RefreshControl: UIRefreshControl {
  var refresh: TriggerSignal = .never
  
  override init() {
    super.init()
    refresh = reactive.controlEvents(.valueChanged).ignoreValues()
  }
  
  required init?(coder _: NSCoder) {
    nil
  }
}

