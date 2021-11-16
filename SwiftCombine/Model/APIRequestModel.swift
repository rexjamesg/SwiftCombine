//
//  APIRequestModel.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

enum APIRequestModel {
    case randomUser
    case randomUserList(page:Int, result:Int=10)
}

extension APIRequestModel: APIProtocol {
    var domain: String {
        return "https://randomuser.me"
    }
    
    var url: URL {
        guard let url = URL(string: domain+path) else {
            fatalError("url could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .randomUser:
            return "/api/"
            
        case .randomUserList:
            return "/api/"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .randomUser:
            return .requestUrlParameters(parameters: nil)
        
        case .randomUserList(let page, let results):
            return .requestUrlParameters(parameters: ["page":page, "results":results])
        }
    }
    
    var commonParameter: [String : Any]? {
        return nil
    }
    
    
}
