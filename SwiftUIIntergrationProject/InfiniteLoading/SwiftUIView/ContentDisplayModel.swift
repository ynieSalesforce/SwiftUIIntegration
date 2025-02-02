//
//  ContentModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation

extension ContentDisplayModel {
  static func createMock(
    numberOfItems: Int,
    pageInfo: PageInfo? = .init(hasNextPage: true, endCursor: "someEndCursor")
  ) -> ContentDisplayModel {
    let count = 1...numberOfItems
    let items = count.map {
      ContentData.createMock(itemNumber: $0, cursor: pageInfo?.endCursor)
    }
    return ContentDisplayModel(pageInfo: pageInfo, items: items)
  }
}

extension ContentData {
  static func createMock(
    id: String = UUID().uuidString,
    itemNumber: Int,
    cursor: String?
  ) -> ContentData {
    let label = "Label: \(randomString(length: itemNumber)) with cursor: \(cursor ?? "No Cursor")"
    let content = "Content: \(randomString(length: itemNumber)) with cursor: \(cursor ?? "No Cursor")"
    return ContentData.init(id: id, label: label, content: content)
  }
}

private func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
