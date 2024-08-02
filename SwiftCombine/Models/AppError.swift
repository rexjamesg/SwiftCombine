//
//  AppError.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2024/7/14.
//

import Foundation

// MARK: - APPError

enum APPError: Error {
    case networkError(error: NetworkError)
    case statusCodeError(statusCode: Int)
    case apiError(error: APIError)
    case noSelf

    // 伺服器連線錯誤
    enum StatusCodeError: Error {
        case authenticationError
        case failed
        case badRequest
        case serverError
        case outdated
        case unknowned
    }

    // 網路連線錯誤
    enum NetworkError: Error {
        case encodeFail
        case missingURL
        case noResponse
        case networkError
        case unableToDecode
        case emptyData
        case networkDisable
        case customError(error: String)
    }

    // API端錯誤
    enum APIError: Error {
        case loginFail
        case emptyList
        case invalidToken
        case notAuthorized
        case unownedError
    }
}

extension APPError {
    var description: String? {
        switch self {
        case let .networkError(error):
            return APPError.getNetworkErrorDescription(error: error)
        case let .statusCodeError(statusCode):
            return APPError.getStatusCodeErrorDescription(statusCode: statusCode)
        case let .apiError(error):
            return APPError.getApiErrorDescription(error: error)
        case .noSelf:
            return "物件不存在"
        }
    }

    // APP端連線錯誤
    static func getNetworkErrorDescription(error: NetworkError) -> String {
        switch error {
        case .encodeFail:
            return "解析失敗"
        case .missingURL:
            return "無法使用的網址"
        case .noResponse:
            return "沒有收到回應"
        case .unableToDecode:
            return "無法解析資料"
        case .emptyData:
            return "收到空的資料"
        case let .customError(error):
            return error.description
        case .networkError:
            return "網路錯誤"
        case .networkDisable:
            return "未開啟網路"
        }
    }

    // 網路層錯誤
    static func getStatusCodeErrorDescription(statusCode: Int) -> String? {
        let error = handleResponseError(statusCode: statusCode)
        let errorMsg = "\(statusCode) "
        switch error {
        case .authenticationError:
            return errorMsg + "驗證錯誤"
        case .badRequest:
            return errorMsg + "錯誤的請求"
        case .outdated:
            return errorMsg + "請求已過期"
        case .failed:
            return errorMsg + "讀取失敗"
        case .serverError:
            return errorMsg + "伺服器連線錯誤"
        case .unknowned:
            return errorMsg + "未知的錯誤"
        }
    }

    // API錯誤
    static func getApiErrorDescription(error: APIError) -> String? {
        switch error {
        case .loginFail:
            return "登入失敗"
        case .invalidToken:
            return "無效的令牌"
        case .notAuthorized:
            return "尚未授權"
        case .emptyList:
            return ""
        case .unownedError:
            return "未知的API錯誤"
        }
    }

    // 處理API回傳的錯誤碼
//    static func handleApiError(errorCode: Int) -> APIError? {
//        switch errorCode {
//        case 1000:
//            return .invalidToken
//        case 2000:
//            return .loginFail
//        case 3000:
//            return .notAuthorized
//        default:
//            return .unownedError
//        }
//    }

    /**
     處理Response錯誤
     - Parameter statusCode: 回應的statusCode
     - Returns StatusCodeError
     */
    static func handleResponseError(statusCode: Int) -> StatusCodeError {
        switch statusCode {
        case 401 ... 403:
            return .authenticationError

        case 404:
            return .failed

        case 405 ... 500:
            return .badRequest

        case 501 ... 599:
            return .serverError

        case 600:
            return .outdated

        default:
            return .unknowned
        }
    }
}
