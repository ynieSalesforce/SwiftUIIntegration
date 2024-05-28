//
//  InfiniteContentView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct InfiniteContentView: View {
  @State var store: StoreOf<InfiniteContentStore>
  
  var body: some View {
    switch store.contentItems {
    case .loading:
      ProgressView().padding()
        .onLoad {
          store.send(.loadInitialContent)
        }
    case .dataLoaded(let displayModel):
      InfiniteLoadingView<InfiniteListItem, ContentDisplayModel, ContentData>(
        displayData: displayModel,
        content: { content in
          InfiniteListItem(content: content)
        }, viewMoreAction: {
          store.send(.loadNextPage(store.state.contentItems.data?.pageInfo))
        })
    case .empty:
      Text("This view is empty")
    case .error(let error):
      Text("This is the error view: \(error.debugDescription)")
    }
  }
}

struct InfiniteListItem: View {
  var content: ContentData
  
  var body: some View {
    VStack (alignment: .leading) {
      Text(content.content)
        .fixedSize(horizontal: false, vertical: true)
        .lineLimit(nil)
        .padding([.horizontal, .top], 16)
        .padding(.bottom, 24)
      Text(content.label)
        .lineLimit(nil)
        .padding([.horizontal, .bottom], 16)
        .fixedSize(horizontal: false, vertical: true)
    }.listRowSeparator(.hidden)
  }
}
