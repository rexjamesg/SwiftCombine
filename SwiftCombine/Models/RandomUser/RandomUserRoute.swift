//
//  RandomUserRoute.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit

// MARK: - RandomUserRoute

enum RandomUserRoute {
    case randomUser
    case randomUserList(page: Int, result: Int = 10)
}

// MARK: APIProtocol

extension RandomUserRoute: APIProtocol {
    var domain: String {
        return "https://randomuser.me"
    }

    var url: URL {
        guard let url = URL(string: domain + path) else {
            fatalError("url could not be configured.")
        }
        return url
    }

    var path: String {
        return "/api"
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var task: HTTPTask {
        return .requestUrlParameters
    }

    var parameters: [String : Any]? {
        switch self {
        case .randomUser:
            return nil
        case let .randomUserList(page, results):
            return ["page": page, "results": results]
        }
    }

    var additionalHeaders: HTTPHeaders? {
        return nil
    }
}
