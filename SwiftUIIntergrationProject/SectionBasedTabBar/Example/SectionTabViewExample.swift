//
//  SectionTabViewExample.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SectionTabViewExample: View {
  @Bindable var store: StoreOf<SectionTabStoreExample>
  @State var height: CGFloat? = 0
  
  var body: some View {
    VStack {
      SectionBasedTabBarView(
        store: store.scope(state: \.tabState, action: \.tabBarAction),
        cellMaxHeight: $height,
        loadSectionView: sectionView)
      
      Spacer()
    }
  }
  
  @ViewBuilder
  private func sectionView(tabBarType: TabSectionExample) -> some View {
    VStack(spacing: .tdsNone) {
      Text(tabBarType.labelText)
    }
    
  }
}

#Preview {
  SectionTabViewExample(
    store: .init(initialState: .init(
      tabState:
          .init(types: [TabSectionExample.first, TabSectionExample.second], selectedTab: .first)), reducer: {
      SectionTabStoreExample()
    }), height: 0)
}
