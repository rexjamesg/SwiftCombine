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
    }
}

private extension RandomUserViewModel {
    func bind() {
        input.load.flatMap({ [weak self] page -> SingleResult<RandmoUserList> in
            guard let self = self else {
                return Just(.failure(.noSelf)).eraseToAnyPublisher()
            }
            self.isLoading = true
            return self.randomUserApi.getUserList(page: page, result: 20)
        }).sink { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let list):
                self.currentPage += 1
                self.randomUsers += list.results
                self.output.didReceiveList.send(self.randomUsers)
            case .failure(let error):
                print(error)
            }
            self.isLoading = false
        }.store(in: &subscribers)
    }
}


//MARK: - Input and OutPut
extension RandomUserViewModel {
    struct Input {
        let load:PassthroughSubject<Int, Never> = .init()
    }
    
    struct Output {
        let didReceiveList:PassthroughSubject<[RandomUser], Never> = .init()
    }
}
