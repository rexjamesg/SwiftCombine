//
//  RandomUserApi.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation
import Combine

class RandomUserApi {
    //MARK: - Private Properties
    private let apiLoader = ApiLoader()

    func getUserList(page: Int, result: Int=20) -> SingleResult<[RandomUser]> {
        apiLoader.getAPI(api: .randomUserList(page: page, result: result), type: RandmoUserList.self, retryTimes: 3)
            .map {
                switch $0 {
                case .success(let list):
                    if let results = list.results {
                        return .success(results)
                    }
                    return .failure(APPError.apiError(error: .emptyList))
                case .failure(let error):
                    return .failure(error)
                }
            }
            .eraseToAnyPublisher()
    }

    func getRandomUser() -> SingleResult<RandomUser> {
        apiLoader.getAPI(api: .randomUser, type: RandmoUserList.self, retryTimes: 3).map({ result in
            switch result {
            case .success(let list):
                if let item = list.results?.first {
                    return .success(item)
                } else {
                    return .failure(.apiError(error: .emptyList))
                }
            case .failure(let error):
                return .failure(error)
            }
        }).eraseToAnyPublisher()
    }
}
