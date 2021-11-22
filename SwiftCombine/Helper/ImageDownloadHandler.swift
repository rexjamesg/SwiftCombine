//
//  ImageDownloadHandler.swift
//  SwiftCombine
//
//  Created by Rex Lin on 2021/10/12.
//

import UIKit

final class ImageDownloadHandler: NSObject {
    
    static let shared:ImageDownloadHandler = ImageDownloadHandler()
    let imageCache = NSCache<AnyObject, AnyObject>()
            
    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    public func downloadImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async() {
                completion(.success(data))
            }
        }.resume()
    }
}


// MARK: - UIImageView extension
extension UIImageView {
    
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String, defaultImage:UIImage?=nil,completion:@escaping()->Void) {
        guard let url = URL(string: urlSting) else { return }
        image = defaultImage
        
        if let imageFromCache = ImageDownloadHandler.shared.imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        ImageDownloadHandler.shared.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                ImageDownloadHandler.shared.imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = UIImage(data: data)
            case .failure(_):
                self.image = defaultImage
            }
            completion()
        }
    }
    
    func setImage(urlSting:String) {
        loadThumbnail(urlSting: urlSting, completion: {
            self.setNeedsLayout()
        })
    }
}
