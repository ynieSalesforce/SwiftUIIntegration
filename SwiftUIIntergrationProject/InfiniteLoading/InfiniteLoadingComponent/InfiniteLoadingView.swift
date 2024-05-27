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
  @Binding var displayData: any Pageable<Value>
  private let contentView: (Value) -> ContentView
  
  init(
    displayData: Binding<any Pageable<Value>>,
    @ViewBuilder content: @escaping (Value) -> ContentView
  ) {
    _displayData = displayData
    self.contentView = content
  }
  
  var body: some View {
    VStack {
      List {
        ForEach(displayData.items) { item in
          contentView(item)
        }
      }
    }
  }
}
