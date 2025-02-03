//
//  TodoViewModel.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import Foundation
import SwiftUI

// 建立一個 ViewModel 管理待辦事項，並使用 ObservableObject 來讓 View 自動更新
class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = []

    init() {
        items = [TodoItem(title: "AAAA"),
                 TodoItem(title: "BBBBB"),
                 TodoItem(title: "CCCC"),
                 TodoItem(title: "DDD")]
    }

    func addTodo(title: String) {
        let newItem = TodoItem(title: title)
        items.append(newItem)
    }

    func toggleCompletion(for item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isCompleted.toggle()
        }
    }

    // 刪除待辦事項
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
