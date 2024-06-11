//
//  SectionBasedTabBarView.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 6/11/24.
//

import Combine
import ComposableArchitecture
import Foundation
import SwiftUI

struct SectionBasedTabBarView<
  TabType: Identifiable & Equatable & Labeled,
  SectionView: View
>: View {
  @Bindable var store: StoreOf<SectionBasedTabBarStore<TabType>>
  @Binding private var cellMaxHeight: CGFloat?
  
  private let detector: CurrentValueSubject<CGFloat, Never>
  private let publisher: AnyPublisher<CGFloat, Never>
  private let scrollId: String = "StampTabView"
  @ViewBuilder private var loadSectionView: (TabType) -> SectionView
  
  init(
    store: StoreOf<SectionBasedTabBarStore<TabType>>,
    cellMaxHeight: Binding<CGFloat?>,
    @ViewBuilder loadSectionView: @escaping (TabType) -> SectionView
  ) {
    self.store = store
    _cellMaxHeight = cellMaxHeight
    
    let detector = CurrentValueSubject<CGFloat, Never>(0)
    
      // publishes value when scrollview has stopped. A delay is needed here otherwise when scroll
      // view value is not zero, it would force the scrollview back into its end position
    publisher = detector
      .debounce(for: .seconds(0.1), scheduler: DispatchQueue.main)
      .dropFirst()
      .eraseToAnyPublisher()
    
    self.detector = detector
    self.loadSectionView = loadSectionView
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: .tdsNone) {
      TabSectionPickerView<TabType>.init(selectedTab:
                                          $store.selectedTab.sending(\.selectTab),
                                         types: store.types)
      
      buildTabView()
    }
  }
  
  @ViewBuilder
  private func buildTabView() -> some View {
    GeometryReader { reader in
      ScrollView(.horizontal, showsIndicators: false) {
        ScrollViewReader { proxy in
          HStack(alignment: .top) {
            ForEach(store.types) { tabType in
              loadSectionView(tabType)
                .frame(width: reader.size.width)
                .readHeight()
            }
          }
            // Handles tapping on picker
          .onChange(of: store.state.selectedTab, { _, newValue in
            withAnimation {
              proxy.scrollTo(newValue, anchor: .leading)
            }
          })
          // handles setting picker value when scroll view stops
          .onReceive(publisher) { value in
            if let tagType = store.types.first(where: { item in
              if value > 0, item.tagIndex > 0 {
                return true
              } else if value == 0, item.tagIndex == 0 {
                return true
              }
              return false
            }) {
              store.send(.selectTab(tagType))
            }
          }.detectPosition(scrollId: scrollId) { detector.send($0) }
            // Sets section height
            .onPreferenceChange(CellHeightPreferenceKey.self) {
              guard $0 > 1 else { return }
              cellMaxHeight = $0
            }
            .onLoad {
              guard store.selectedTab == store.types[1] else { return }
              proxy.scrollTo(1, anchor: .leading)
            }
        }
      }
      .coordinateSpace(name: scrollId)
      .scrollTargetLayout()
      .scrollTargetBehavior(.paging)
    }.frame(height: cellMaxHeight)
  }
}

private struct TabSectionPickerView<TabType: Identifiable & Equatable & Labeled>
: View {
  @Binding var selectedTab: TabType
  var types: [TabType]
  var body: some View {
    Picker("", selection: $selectedTab) {
      ForEach(types) {
        Text($0.labelText).tag($0.tagIndex)
      }
    }
    .pickerStyle(.segmented)
    .padding(.horizontal, .tdsMedium)
    .padding(.bottom, .tdsMedium)
    .background(Color(uiColor: .systemBackground))
  }
}

struct ViewOffsetKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value += nextValue()
  }
}

extension View {
  func detectPosition(scrollId: String, onChange: @escaping (CGFloat) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(
            key: ViewOffsetKey.self,
            value: geometryProxy.frame(in: .named(scrollId)).origin.x * -1
          )
      }
    )
    .onPreferenceChange(ViewOffsetKey.self, perform: onChange)
  }
}
