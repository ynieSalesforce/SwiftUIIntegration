//
//  InfiniteLoadingComponent.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/3/24.
//

import Foundation
import SwiftUI

struct InfiniteLoadingComponent<
  ContentView: View,
  Value: Identifiable & Equatable & Hashable
>: View {
  
  var displayData: PagingDisplayData<Value>
  @ViewBuilder let contentView: (Value) -> ContentView
  let viewMoreAction: () -> Void
  
  var body: some View {
    VStack {
      List {
        ForEach(displayData.items) { item in
          contentView(item)
        }
        if let pageInfo = displayData.pageInfo,
           pageInfo.hasNextPage {
          loadingCell()
            .onAppear(perform: viewMoreAction)
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
