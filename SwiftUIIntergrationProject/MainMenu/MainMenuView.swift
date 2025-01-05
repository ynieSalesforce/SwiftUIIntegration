//
//  MainMenuView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/3/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

enum DemoType {
  case uiKit
  case mix
  case swiftUI
  case infiniteLoading
  case infiniteLoadingReusable
  case sectionTabBar
  case sampleNavigation
}

extension DemoType: CaseIterable {
  var title: String {
    switch self {
    case .uiKit:
      return "UIKit and ReactiveSwift View Model"
    case .mix:
      return "SwiftUI with Async and Reactive Swift View Model"
    case .swiftUI:
      return "SwiftUI and Composable Architecture"
    case .infiniteLoading:
      return "Infinite Loading"
    case .infiniteLoadingReusable:
      return "Infinite Loading with reusable component"
    case .sectionTabBar:
      return "Section Tab Bar"
    case .sampleNavigation:
      return "Sample Navigation Demo"
    }
  }
}

//struct MainMenuView: View {
//  private let options: [DemoType] = DemoType.allCases
//  @Bindable var store: StoreOf<MainMenu>
//  
//  var body: some View {
//    LazyVStack {
//      ForEach(options, id: \.self) { option in
//        VStack {
//          menuItemView(with: option)
//          if option != options.last {
//            Divider()
//          }
//        }
//      }
//      Spacer()
//    }
//  }
//  
//  @ViewBuilder
//  private func menuItemView(with type: DemoType) -> some View {
//    HStack(alignment: .center) {
//      Text(type.title)
//        .padding([.leading, .top, .bottom], .tdsMedium)
//        .font(.title2)
//      
//      Spacer()
//      
//      Image(systemName: "chevron.right")
//        .font(.title2)
//        .padding(.trailing, .tdsMedium)
//    }.onTapGesture {
//      if type == .sampleNavigation {
//        store.send(.loadSampleView("I'm getting a real job"))
//      }
//    }
//  }
//}
