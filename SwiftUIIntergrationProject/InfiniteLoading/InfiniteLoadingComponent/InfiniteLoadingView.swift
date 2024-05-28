//
//  InfiniteLoadingView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation
import SwiftUI

public struct PageInfo: Equatable, Codable {
  public let hasNextPage: Bool
  public let endCursor: String?
}

public protocol Pageable <Value> {
  associatedtype Value: Identifiable & Hashable
  var items: [Value] { get set }
  var pageInfo: PageInfo? { get set }
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
      ProgressView().padding()
    }
  }
}
