//
//  UIImageView+WebImage.swift
//  Pods
//
//  Created by 王小涛 on 2017/8/23.
//
//

import Kingfisher

public extension WebImage where Base: UIImageView {
    
    public func setImage(withURLString urlString: String?,
                         placeholder: UIImage? = nil,
                         progress: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                         success: ((UIImage) -> Void)? = nil,
                         failure: ((NSError) -> Void)? = nil){
    
        let url: URL? = {
            guard let urlString = urlString else {
                return nil
            }
            return URL(string: urlString)
        }()
        
        setImage(with: url, placeholder: placeholder, progress: progress, success: success, failure: failure)
    }
    
    public func setImage(with url: URL?,
                  placeholder: UIImage? = nil,
                  progress: ((_ receivedSize: Int64, _ totalSize: Int64) -> Void)? = nil,
                  success: ((UIImage) -> Void)? = nil,
                  failure: ((NSError) -> Void)? = nil) {
        base.kf.setImage(with: url, placeholder: placeholder, progressBlock: progress) { (image, error, _, _) in
            if let image = image {
                success?(image)
            } else {
                failure?(error!)
            }
        }
    }
}
