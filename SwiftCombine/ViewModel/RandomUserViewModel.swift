//
//  RandomUserViewModel.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/11/22.
//

import UIKit
import Combine

class RandomUserViewModel {

    //MARK: - Public Properties
    let input = Input()
    let output =  Output()
    var tableViewDiffableDataSource:UITableViewDiffableDataSource<Int, RandomUser>?
    
    //MARK: - Private Properties
    private let randomUserApi = RandomUserApi()
    private var subscribers = [AnyCancellable]()
    private(set) var randomUsers = [RandomUser]()
    private(set) var isLoading = false
    private(set) var currentPage = 1
    
    init() {
        bind()
        randomUserApi.getRandomUser().sink { result in
            switch result {
            case .success(let success):
                print("success", success)
            case .failure(let failure):
                print("failure", failure)
            }
        }.store(in: &subscribers)
    }
}

private extension RandomUserViewModel {
    func bind() {
        input.load.flatMap({ [weak self] page -> SingleResult<[RandomUser]> in
            guard let self = self else {
                return Just(.failure(.noSelf)).eraseToAnyPublisher()
            }
            self.isLoading = true
            return self.getUserList(page: page)
        }).sink { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.currentPage += 1
                self.randomUsers += list
                self.output.didReceiveList.send(self.randomUsers)
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }.store(in: &subscribers)

        input.refteshData.flatMap { [weak self] _ -> SingleResult<[RandomUser]> in
            guard let self = self else {
                return Just(.failure(.noSelf)).eraseToAnyPublisher()
            }
            self.isLoading = true
            self.currentPage = 1
            return self.getUserList(page: currentPage)
        }.sink { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let list):
                self.randomUsers = list
                self.output.didReceiveList.send(self.randomUsers)
            case .failure(let error):
                print(error)
            }
        }.store(in: &subscribers)
    }

    func getUserList(page: Int) -> SingleResult<[RandomUser]> {
        self.isLoading = true
        return randomUserApi.getUserList(page: page, result: 20)
    }
}


//MARK: - Input and OutPut
extension RandomUserViewModel {
    struct Input {
        let load:PassthroughSubject<Int, Never> = .init()
        let refteshData: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        let didReceiveList:PassthroughSubject<[RandomUser], Never> = .init()
    }
}
