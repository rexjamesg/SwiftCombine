//
//  RouterDefinition.swift
//  APITableView_MVVM
//
//  Created by Rex Lin on 2020/7/2.
//  Copyright © 2020 Yu Li Lin. All rights reserved.
//

import UIKit

// MARK: - APIProtocol

/// API協議
public protocol APIProtocol {
    var domain: String { get }
    var url: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var parameters: [String: Any]? { get }
    var additionalHeaders: HTTPHeaders? { get }
}

/// 定義Header別名
public typealias HTTPHeaders = [String: String]
/// 定義參數別名
public typealias Parameters = [String: Any]

// MARK: - HTTPMethod

/// HTTP方法(目前只列出常用的兩種，可擴充)
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - HTTPTask

/**
 Service
 ````
 case requestBodyParameters(parameters:Parameters?)
 case requestUrlParameters(parameters:Parameters?)
 case requestFormdataParameter(parameters:Parameters?)
 ````
 */
public enum HTTPTask {
    /// 參數加入至httpBody
    case requestBodyParameters
    /// 參數加入至網址後方
    case requestUrlParameters
    /// 參數由formdata方式傳送(可傳送圖片)
    case requestFormDataParameters
}

internal extension NSMutableData {
    /// 將參數相加(formdata使用)
    func appendString(_ string: String) {
        if let data = string.data(using: String.Encoding.utf8) {
            append(data)
        }
    }
}

internal extension URLComponents {
    /// 將多個參數轉成網址後方參數 (urlRequest使用)
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
