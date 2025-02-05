//
//  ChatRoomViewModel.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/5.
//

import Combine
import Foundation
import UIKit

// MARK: - ChatItem

struct ChatItem: Codable, Hashable {
    let name: String
    let content: String
    let dateTime: Date
}

// MARK: - ChatRoomViewModel

class ChatRoomViewModel {
    // MARK: - Public Properties

    let input = Input()
    let output = Output()
    var tableViewDiffableDataSource: UITableViewDiffableDataSource<Int, ChatItem>?
    
    // MARK: - Private Properties

    private(set) var chatItems = [ChatItem]()
    private var pendingMessages = [ChatItem]()
    private var subscribers = [AnyCancellable]()
    private var isUpdating = false
    
    init() {
        bind()
    }
}

// MARK: - Bind

private extension ChatRoomViewModel {
    func bind() {
        input.load.flatMap { [weak self] _ -> SingleResult<[ChatItem]> in
            guard let self = self else {
                return Just(.failure(.noSelf)).eraseToAnyPublisher()
            }
            return Just(.success(self.getFakeData())).eraseToAnyPublisher()
        }.sink { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.pendingMessages.append(contentsOf: items)
                self.batchInsertMessages(messages: items)  {
                    self.output.didReceivedChatItem.send(self.chatItems)
                }
            case .failure(let error):
                print(error)
            }
        }.store(in: &subscribers)
    }
}

// MARK: - Private Methods

private extension ChatRoomViewModel {
    func getFakeData() -> [ChatItem] {
        
        var chatItems = [ChatItem]()

        for i in 0 ..< Int.random(in: 1...5) {
            let item = ChatItem(name: "Name\(i)", content: "Content\(i)", dateTime: Date())
            chatItems.append(item)
        }

        return chatItems
    }
    
    func batchInsertMessages(messages: [ChatItem], completion: (()->Void)?=nil) {
        guard !isUpdating else { return }  // ❶ 防止同時執行多個插入操作
        isUpdating = true  // ❷ 標記正在進行批量更新

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            print("self.pendingMessages count", self?.pendingMessages.count)
            guard let self = self else { return }
            // ❸ 延遲 0.5 秒執行
            //let startIndex = self.chatItems.count  // ❹ 記錄插入前的最後一個索引
            
            self.chatItems.append(contentsOf: self.pendingMessages)  // ❺ 將待插入的訊息加入主訊息陣列

//            let indexPaths = (startIndex..<self.chatItems.count).map {
//                IndexPath(row: $0, section: 0)
//            }  // ❻ 根據新增的訊息數量，建立要插入的 `IndexPath` 陣列

            //self.tableView.insertRows(at: indexPaths, with: .automatic)  // ❼ 插入新訊息到 TableView，並使用動畫效果

            self.pendingMessages.removeAll()  // ❽ 清空 `pendingMessages`，表示這批訊息已處理
            self.isUpdating = false  // ❾ 解鎖，允許下一次批量插入
            completion?()
        }
    }
}

extension ChatRoomViewModel {
    struct Input {
        let load: PassthroughSubject<Void, Never> = .init()
    }

    struct Output {
        let didReceivedChatItem: PassthroughSubject<[ChatItem], Never> = .init()
    }
}
