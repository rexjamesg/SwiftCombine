//
//  DownloadOperation.swift
//  SwiftCombine
//
//  Created by Yu Li Lin on 2025/3/4.
//

import Combine
import Foundation
import UIKit

// MARK: - DownloadOperation

class DownloadOperation: Operation {
    let url: URL
    var downloadedImage: UIImage?

    // MARK: - Private Properties

    private var cancellable: AnyCancellable?

    // MARK: 非同步 Operation 必須管理執行狀態

    private var _isExecuting = false
    override private(set) var isExecuting: Bool {
        get { _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished = false
    override private(set) var isFinished: Bool {
        get { _isFinished }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    override var isAsynchronous: Bool {
        return true
    }

    init(url: URL) {
        self.url = url
    }

    override func start() {
        if isCancelled {
            finish()
            return
        }
        isExecuting = true

        cancellable = downloadImage(url: url)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("下載成功")
                case let .failure(error):
                    print("下載失敗: \(error.localizedDescription)")
                }
                self.finish()
            }, receiveValue: { [weak self] image in
                guard let self = self else { return }
                self.downloadedImage = image                
            })
    }

    override func cancel() {
        super.cancel()
        cancellable?.cancel()
        finish()
    }
}

// MARK: - Private Properties

private extension DownloadOperation {
    /// 使用 Combine 下載圖片
//    func downloadImage(url: URL) -> AnyPublisher<UIImage?, Never> {
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { data, _ in UIImage(data: data) }
//            .replaceError(with: nil) // 發生錯誤時回傳 nil
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }

    /// 使用 Combine 下載圖片
    func downloadImage(url: URL) -> AnyPublisher<UIImage, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> UIImage in
                guard let response = response as? HTTPURLResponse, (200 ... 209).contains(response.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeRawData)
                }
                return image
            }.eraseToAnyPublisher()
    }

    func finish() {
        isExecuting = false
        isFinished = true
    }
}
