//
//  SwiftUIRandomUserViewModel.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/2/17.
//

import Combine
import Foundation
import SwiftUI

class SwiftUIRandomUserViewModel: ObservableObject {
    @Published var randomUsers = [RandomUser]()
    @Published var isLoading = false

    // MARK: - Private Properties

    private let randomUserApi = RandomUserApi()
    private var subscribers = [AnyCancellable]()
    private(set) var currentPage = 1

    func loadUsers() {
        guard !isLoading else { return }
        isLoading = true

        randomUserApi.getUserList(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case let .success(list):
                self.randomUsers += list
                self.currentPage += 1
            case let .failure(error):
                print("error", error)
            }
        }.store(in: &subscribers)
    }

    func refreshUser() {
        guard !isLoading else { return }
        isLoading = true

        currentPage = 1

        randomUserApi.getUserList(page: currentPage)
            .sink { [weak self] result in
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                case let .success(list):
                    self.randomUsers = list // ✅ 這樣 SwiftUI 會自動更新 UI
                case let .failure(error):
                    print(error)
                }
            }
            .store(in: &subscribers)
    }
}
