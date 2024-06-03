//
//  InfiniteLoadingView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI

public protocol Pageable <Value> {
  associatedtype Value: Identifiable & Equatable
  var items: [Value] { get }
  var pageInfo: PageInfo? { get }
}

struct InfiniteLoadingView<
  ContentView: View,
  DisplayData: Pageable<Value>,
  Value: Identifiable
>: View {
  
  var displayData: any Pageable<Value>
  @ViewBuilder let contentView: (Value) -> ContentView
  let viewMoreAction: () -> Void
  init(
    displayData: any Pageable<Value>,
    @ViewBuilder content: @escaping (Value) -> ContentView,
    viewMoreAction: @escaping () -> Void
  ) {
    self.displayData = displayData
    self.contentView = content
    self.viewMoreAction = viewMoreAction
  }
  
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
