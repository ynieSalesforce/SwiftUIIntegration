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
      
    }
  }
  
  @ViewBuilder
  private func pickerView(@Binding tabType: TabType) -> some View {
    Picker("", selection: $tabType) {
      Text(tabType.labelText).tag(tabType.tagIndex)
      Text(tabType.labelText).tag(tabType.tagIndex)
    }
    .pickerStyle(.segmented)
    .padding(.horizontal, .tdsMedium)
    .padding(.bottom, .tdsMedium)
    .background(Color(uiColor: .systemBackground))
  }
  
  @ViewBuilder
  private func buildTabView() -> some View {
    GeometryReader { reader in
      ScrollView(.horizontal, showsIndicators: false) {
        ScrollViewReader { proxy in
          HStack(alignment: .top) {
            ForEach(store.types) { tabType in
              loadSectionView(tabType).readHeight()
            }
          }
            // Handles tapping on picker
          .onChange(of: store.state.selectedTab, { _, newValue in
            withAnimation {
              proxy.scrollTo(newValue, anchor: .leading)
            }
          })
            // handles setting picker value when scroll view stops
          .onReceive(publisher) {
            store.send(.selectedTab(Int($0)))
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

//#Preview {
//  let store = StoreOf<StampsStore>.init(
//    initialState: .init(),
//    reducer: { StampsStore(stampViewLocation: .profile, delegate: nil) }
//  )
//  return StampsTabView(store: .constant(store), cellMaxHeight: .constant(nil))
//    .onLoad {
//      store.send(.loadData("test123", true))
//    }
//}

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
