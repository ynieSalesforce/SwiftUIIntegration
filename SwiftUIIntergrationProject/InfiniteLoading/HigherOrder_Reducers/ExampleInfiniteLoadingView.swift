//
//  ExampleInfiniteLoadingView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/3/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct ExampleInfiniteLoadingView: View {
  @State var store: StoreOf<ExampleInfiniteLoadingStore>
  
  var body: some View {
    if store.infiniteState.isLoading {
      ProgressView().padding()
        .onLoad {
          store.send(.infiniteAction(.loadInitialData))
        }
    } else if let error = store.infiniteState.error {
      Text("This is the error view: \(error.localizedDescription)")
    } else {
      InfiniteLoadingComponent<InfiniteListItem, ContentData>(
        displayData: store.infiniteState.displayData,
        contentView: { content in
          InfiniteListItem(content: content)
        },
        store: store.scope(state: \.infiniteState, action: \.infiniteAction))
    }
  }
}
