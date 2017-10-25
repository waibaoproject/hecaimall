//
//  ImageDownloaderType.swift
//  Pods
//
//  Created by 王小涛 on 2017/8/23.
//
//

import Kingfisher

public protocol ImageDownloaderType {
    func donwloadImage(with url: URL,
                       progress: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)?,
                       success: ((UIImage) -> Void)?,
                       failure: ((NSError) -> Void)?)
}

extension ImageDownloaderType {
    public func donwloadImage(with url: URL,
                              progress: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                              success: ((UIImage) -> Void)? = nil,
                              failure: ((NSError) -> Void)? = nil) {
        
        ImageDownloader.default.downloadImage(with: url, progressBlock: progress) { (image, error, _, _) in
            if let image = image {
                DefaultImageCache.shared.store(image, forKey: url.absoluteString)
                success?(image)
            } else {
                failure?(error!)
            }
        }
    }
}

public class DefaultImageDownloader: ImageDownloaderType {
    public static let shared = DefaultImageDownloader()
    private init() {}
}
