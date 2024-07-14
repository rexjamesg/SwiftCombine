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
    
    func getUserList(page: Int, result: Int=20) -> SingleResult<RandmoUserList> {
        apiLoader.getAPI(api: .randomUserList(page: page, result: result), type: RandmoUserList.self).eraseToAnyPublisher()
    }
}
