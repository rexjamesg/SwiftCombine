//
//  ApiLoader.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/8.
//

import Combine
import UIKit

typealias SingleResult<T: Codable> = AnyPublisher<Result<T, APPError>, Never>

// MARK: - ApiLoader

class ApiLoader: NSObject {
    // MARK: - Private Properties

    private let session: URLSession
    override init() {
        session = URLSession.shared
    }

    func getAPI<T: Codable>(api: RandomUserRoute, type _: T.Type, retryTimes: Int = 0) -> SingleResult<T> {
        return request(api: api)
            .decode(type: T.self, decoder: JSONDecoder())
            .retry(retryTimes)
            .map { Result.success($0) }
            .catch { error in
                Just(Result.failure(error as? APPError ?? .networkError(error: .unableToDecode)))
            }.eraseToAnyPublisher()
    }
}

// MARK: - Private Methods

private extension ApiLoader {
    func request(api: APIProtocol) -> Deferred<Future<Data, APPError>> {
        Deferred {
            Future { [weak self] promise in
                guard let self = self else { return }
                do {
                    let request = try self.buildRequest(api: api)
                    #if DEBUG
                        print("request", request)
                    #endif
                    URLSession.shared.dataTask(with: request) { data, response, _ in
                        guard let response = response as? HTTPURLResponse else {
                            promise(.failure(.networkError(error: .noResponse)))
                            return
                        }

                        if response.statusCode != 200 {
                            promise(.failure(.statusCodeError(statusCode: response.statusCode)))
                            return
                        }

                        guard let data = data else {
                            promise(.failure(.networkError(error: .emptyData)))
                            return
                        }

                        #if DEBUG
                            self.checkJSONData(data: data)
                        #endif

                        promise(.success(data))
                    }.resume()

                } catch {
                    if let error = error as? APPError {
                        return promise(.failure(error))
                    }
                    return promise(.failure(error as? APPError ?? .networkError(error: .customError(error: error.localizedDescription))))
                }
            }
        }
    }

    /**
     建立請求
     - parameter api: 遵循APIProtocol協議的類
     */
    func buildRequest(api: APIProtocol) throws -> URLRequest {
        var request = URLRequest(url: api.url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        request.httpMethod = api.httpMethod.rawValue

        let fullParameters = appendCommonParameters(api: api, parameters: api.parameters)
        try configureParameters(bodyParameters: fullParameters.body, urlParameters: fullParameters.url, formDataParameters: fullParameters.formData, request: &request)

        if let headers = api.additionalHeaders {
            addAdditionalHeaders(headers, request: &request)
        }

        return request
    }

    func appendCommonParameters(api: APIProtocol, parameters: Parameters?) -> (body: Parameters?, url: Parameters?, formData: Parameters?) {
        var fullParameters = parameters ?? [:]
        if let parameters = api.parameters {
            fullParameters.merge(parameters) { _, new in new }
        }

        switch api.task {
        case .requestBodyParameters:
            return (body: fullParameters, url: nil, formData: nil)
        case .requestUrlParameters:
            return (body: nil, url: fullParameters, formData: nil)
        case .requestFormDataParameters:
            return (body: nil, url: nil, formData: fullParameters)
        }
    }

    /**
     設定請求參數
     - Parameter bodyParameters: 塞在http body裡面的參數
     - Parameter urlParameters: 塞在網址後面的參數
     */
    func configureParameters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, formDataParameters: Parameters? = nil, request: inout URLRequest) throws {
        if let bodyParameters = bodyParameters {
            try jsonEncode(urlRequest: &request, with: bodyParameters)
        }

        if let urlParameters = urlParameters {
            try urlParameterEncode(urlRequest: &request, with: urlParameters)
        }

        if let formDataParameters = formDataParameters {
            try boundaryEncode(urlRequest: &request, with: formDataParameters)
        }
    }

    /**
     以JSON格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    func jsonEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .fragmentsAllowed)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
    }

    /**
     以formData格式傳遞參數
     - Parameter urlRequest: 請求
     - Parameter parameters: 參數
     */
    func boundaryEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        // boundary可自定義
        let boundary = "=========="
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
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
    func urlParameterEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw APPError.networkError(error: .missingURL) }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            urlRequest.url = urlComponents.url
        }
    }

    /**
     加入額外的Header
     */
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        additionalHeaders?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    }

    func checkJSONData(data: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print("json", json as Any)
        } catch {
            print("checkJSONData error message: ", error)
        }
    }
}
