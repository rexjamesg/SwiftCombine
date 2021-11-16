//
//  DataHandler.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit
import Combine

final class DataHandler: NSObject {
    
    static let shared:DataHandler = DataHandler()
    let urlTaskPublisher:URLTaskPublisher = URLTaskPublisher()
    var subscribers:[AnyCancellable] = []
    
    private override init() {
        super.init()
    }
    
    func getAPI<T:Codable>(apiDataModel:APIRequestModel, dataType:T.Type, completionHandler:@escaping (_ result:Result<T,Error>)->Void) {
                       
        urlTaskPublisher.request(apiDataModel: apiDataModel)
            .decode(type: T.self, decoder: JSONDecoder())
            .retry(3)
            .sink { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        } receiveValue: { value in
            completionHandler(.success(value))
        }.store(in: &subscribers)
    }

}
