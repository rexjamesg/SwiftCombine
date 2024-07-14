//
//  ApiLoader.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import UIKit
import Combine

typealias SingleResult<T:Codable> = AnyPublisher<Result<T, APPError>, Never>

class ApiLoader: NSObject {
    func getAPI<T: Codable>(api:RandomUserRoute, type:T.Type, retryTimes:Int=0) -> SingleResult<T> {
        return request(api: api)
            .decode(type: T.self, decoder: JSONDecoder())
            .retry(retryTimes)
            .map { Result.success($0) }
            .catch { error in
                if let error = error as? APPError {
                    return Just(Result<T, APPError>.failure(error))
                }

                return Just(Result.failure(APPError.networkError(error: .unableToDecode)))
            }.eraseToAnyPublisher()
    }
    
    func request(api: APIProtocol) -> AnyPublisher<Data, APPError> {
        do {
            let request = try buildRequest(api: api)

            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response in

                    guard let response = response as? HTTPURLResponse else {
                        throw APPError.networkError(error: .noResponse)
                    }

                    #if DEBUG
                        let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                        print("json", json)
                    #endif

                    if response.statusCode != 200 {
                        throw APPError.statusCodeError(statusCode: response.statusCode)
                    }

                    return data
                }
                .catch { error -> AnyPublisher<Data, APPError> in

                    if let error = error as? APPError {
                        return AnyPublisher(Fail(error: error))
                    }

                    return AnyPublisher(Fail(error: .networkError(error: .customError(error: error.localizedDescription))))
                }
                .eraseToAnyPublisher()
        } catch {
            if let error = error as? APPError {
                return AnyPublisher(Fail(error: error))
            }
            return AnyPublisher(Fail(error: APPError.networkError(error: .missingURL)))
        }
    }
    
    /**
     建立請求
     - parameter api: 遵循APIProtocol協議的類
    */
    private func buildRequest<T:APIProtocol>(api: T) throws -> URLRequest {
        
        var request = URLRequest.init(url: api.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        request.httpMethod = api.httpMethod.rawValue
                       
        switch api.task {
            
        case .requestBodyParameters(let parameters):
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: fullParameters, urlParameters: nil, formdataParameter: nil, request: &request)
            
        case .requestUrlParameters(let parameters):
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: nil, urlParameters: fullParameters, formdataParameter: nil, request: &request)
            
        case .requestFormdataParameter(let parameters):
            
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: nil, urlParameters: nil, formdataParameter: fullParameters, request: &request)
            
        case .requestBodyParametersAndHeaders(let parameters, let additionHeaders):
            addAdditionalHeaders(additionHeaders, request: &request)
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: fullParameters, urlParameters: nil, formdataParameter: nil, request: &request)
            
        case .requestUrlParametersAndHeaders(let parameters, let additionHeaders):
            addAdditionalHeaders(additionHeaders, request: &request)
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: nil, urlParameters: fullParameters, formdataParameter: nil, request: &request)
            
        case .requestFormdataParametersAndHeaders(let parameters, let additionHeaders):
            addAdditionalHeaders(additionHeaders, request: &request)
            let fullParameters = appendCommonParameters(api: api, parameters: parameters)
            try configureParameters(bodyParameters: nil, urlParameters: nil, formdataParameter: fullParameters, request: &request)
        }
        
        return request
    }
    
    /**
     加入API固定的參數
     - Parameter api:遵循APIProtocol協議的類
     - Parameter parameters: 要傳送的參數
    */
    private func appendCommonParameters<T:APIProtocol>(api:T, parameters:Parameters?) -> Parameters? {
        //取得API固定的參數
        if var commonParameter = api.commonParameter {
            var originParameters:Parameters = [:]
            if parameters != nil {
                originParameters = parameters!
            }
            commonParameter.merge(originParameters) { (_, second) in second }
            return commonParameter
        }
        
        return parameters
    }
    
    /**
     設定請求參數
     - Parameter bodyParameters: 塞在http body裡面的參數
     - Parameter urlParameters: 塞在網址後面的參數
     */
    private func configureParameters(bodyParameters:Parameters?, urlParameters:Parameters?, formdataParameter:Parameters?, request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try jsonEncode(urlRequest: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try urlParameterEncode(urlRequest: &request, with: urlParameters)
            }
            
            if let formdataParameter = formdataParameter {
                try bounderyEncode(urlRequest: &request, with: formdataParameter)
            }
            
        } catch {
            throw error
        }
    }
        
    /**
     以JSON格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func jsonEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
                        
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = jsonData
            
        } catch {
            throw APPError.networkError(error: .encodeFail)
        }
    }
    
    
    /**
     以formData格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func bounderyEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        //boundary可自定義
        let boundary:String = "=========="
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition:form-data; name='\(key)'\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString("--\(boundary)--")
        urlRequest.httpBody = body as Data
    }
    
    /**
     以網址傳遞參數 (ex: https://www.xxx.xxx?keyA=valueA&keyB=valueB)
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    private func urlParameterEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw APPError.networkError(error: .missingURL) }
        if var urlComponents = URLComponents.init(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryItems:[URLQueryItem] = []
            for (key,value) in parameters {
                let queryItem = URLQueryItem.init(name: key, value: "\(value)")
                queryItems.append(queryItem)
            }
            
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
    }
    
    /**
     加入額外的Header
     */
    func addAdditionalHeaders(_ additionalHeaders:HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}