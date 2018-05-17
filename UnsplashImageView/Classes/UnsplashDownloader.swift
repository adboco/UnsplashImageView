//
//  UnsplashDownloadManager.swift
//  UnsplashImageView
//
//  Created by Adrián Bouza Correa on 17/05/2018.
//

import Foundation
import Alamofire

/// It manages the image downloading
internal final class UnsplashDownloader {
    
    /// Download an image from its url
    ///
    /// - Parameters:
    ///   - url: Image url
    ///   - completion: Completion handler
    static internal func downloadImage(with url: URL?, _ completion: ((UIImage?) -> Void)? = nil) {
        guard let url = url else {
            completion?(nil)
            return
        }
        Alamofire.request(url).responseData { response in
            guard let data = response.value else {
                completion?(nil)
                return
            }
            let image = UIImage(data: data)
            completion?(image)
        }
    }
    
}
