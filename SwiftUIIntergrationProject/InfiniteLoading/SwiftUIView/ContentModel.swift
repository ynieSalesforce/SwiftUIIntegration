//
//  ContentModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/27/24.
//

import Foundation

struct ContentModel: Identifiable, Pageable {
  typealias Value = Content
  var pageInfo: PageInfo?
  let id: String
  var items: [Content]
}

struct Content: Identifiable, Hashable {
  let id: String
  let label: String
  let content: String
}

extension ContentModel {
  static func createMock(
    id: String = UUID().uuidString,
    numberOfItems: Int,
    pageInfo: PageInfo? = .init(hasNextPage: true, endCursor: "someEndCursor")
  ) -> ContentModel {
    let count = 0...numberOfItems
    let items = count.map {
      Content.createMock(itemNumber: $0, cursor: pageInfo?.endCursor)
    }
    return ContentModel(pageInfo: pageInfo, id: id, items: items)
  }
}

extension Content {
  static func createMock(
    id: String = UUID().uuidString,
    itemNumber: Int,
    cursor: String?
  ) -> Content {
    let label = "Label: \(randomString(length: itemNumber)) with cursor: \(cursor ?? "No Cursor")"
    let content = "Content: \(randomString(length: itemNumber)) with cursor: \(cursor ?? "No Cursor")"
    return Content.init(id: id, label: label, content: content)
  }
}

private func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
