//
//  ImageDownloadHandler.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/12.
//

import UIKit

// MARK: - ImageDownloadHandler

final class ImageDownloadHandler: NSObject {
    static let shared: ImageDownloadHandler = .init()

    // MARK: - Private Properties

    fileprivate let imageCache = NSCache<AnyObject, AnyObject>()
    private let urlSession = URLSession.shared

    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public func downloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let cacheKey = url.absoluteString as AnyObject
        if let cachedData = imageCache.object(forKey: cacheKey) as? Data {
            completion(.success(cachedData))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else {
                completion(.failure(APPError.noSelf))
                return
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "ImageDownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            self.imageCache.setObject(data as AnyObject, forKey: cacheKey)
            completion(.success(data))
        }.resume()
    }
}

// MARK: - UIImageView extension

extension UIImageView {
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlString: String, defaultImage: UIImage? = nil, completion: @escaping () -> Void) {
        guard let url = URL(string: urlString) else {
            image = defaultImage
            completion()
            return
        }

        if let cachedImage = ImageDownloadHandler.shared.imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = cachedImage
            completion()
            return
        }

        ImageDownloadHandler.shared.downloadImage(url: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    if let imageToCache = UIImage(data: data) {
                        ImageDownloadHandler.shared.imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    } else {
                        self.image = defaultImage
                    }
                case .failure:
                    self.image = defaultImage
                }
                completion()
            }
        }
    }

    func setImage(urlString: String) {
        loadThumbnail(urlString: urlString, completion: {
            self.setNeedsLayout()
        })
    }
}
