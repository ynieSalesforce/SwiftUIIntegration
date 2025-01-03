//
//  SampleNavigation.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 12/27/24.
//

import Foundation
import ComposableArchitecture
import SwiftNavigation
import SwiftUI

// Feature of the destination
@Reducer
struct SampleNavigation {
  @ObservableState
  struct State: Equatable {
    var id: String
    
    init(id: String) {
      self.id = id
    }
  }
  
  enum Action {
    case tap
  }
}

// Destination SwiftUI View
struct SampleNavigationView: View {
  
  @Bindable var store: StoreOf<SampleNavigation>
  var body: some View {
    VStack {
      Button("Id of view: \(store.id)") {
        store.send(.tap)
      }
    }
  }
}

// Observed Destination Model
@Observable
class SampleNavigationModel {
  var sampleNav: StoreOf<SampleNavigation>
  
  init(sampleNav: StoreOf<SampleNavigation>) {
    self.sampleNav = sampleNav
  }
}

// Destination View Controller
class SampleNavigationController: UIViewController {
  @UIBindable var model: SampleNavigationModel
  
  init(model: SampleNavigationModel) {
    self.model = model
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    var menuView: UIHostingController<SampleNavigationView> = .init(rootView: .init(store: model.sampleNav))
    super.viewDidLoad()
    addChild(menuView)
    view.addSubview(menuView.view)
    menuView.view.snp.updateConstraints { make in
      make.edges.equalTo(view)
    }
    
    navigationItem.title = "Sample Nav controller"
  }
}
