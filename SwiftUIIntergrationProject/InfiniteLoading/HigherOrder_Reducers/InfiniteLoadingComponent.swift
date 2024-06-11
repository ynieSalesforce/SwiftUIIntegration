//
//  InfiniteLoadingComponent.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/3/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct InfiniteLoadingComponent<
  ContentView: View,
  Value: Identifiable & Equatable & Hashable
>: View {
  
  var displayData: PagingDisplayData<Value>
  @ViewBuilder let contentView: (Value) -> ContentView
  @Bindable var store: StoreOf<InfiniteLoadingReducer<Value>>
  
  var body: some View {
    VStack {
      List {
        ForEach(displayData.items) { item in
          contentView(item)
        }
        if let pageInfo = displayData.pageInfo,
           pageInfo.hasNextPage {
          loadingCell()
            .onAppear {
              store.send(.loadNextPage(store.displayData.pageInfo))
            }
        }
      }
    }
  }
  
  @ViewBuilder
  private func loadingCell() -> some View {
    VStack(alignment: .center, spacing: 0) {
      HStack {
        Spacer()
        ProgressView()
        Spacer()
      }.padding(.vertical, 16)
    }
  }
}
