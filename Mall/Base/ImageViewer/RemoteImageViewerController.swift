//
//  RemoteImageViewerController.swift
//  Pods
//
//  Created by 王小涛 on 2017/9/11.
//
//

import WebImage

public struct RemoteImage {
    
    let thumbnailURL: URL?
    let originURL: URL?
    
    public init(thumbnail: String?, origin: String?) {
        if let thumbnail = thumbnail {
            self.thumbnailURL = URL(string: thumbnail)
        } else {
            self.thumbnailURL = nil
        }
        
        if let origin = origin {
            self.originURL = URL(string: origin)
        } else {
            self.originURL = nil
        }
    }
    
    var originCachedImage: UIImage? {
        guard let origin = originURL?.absoluteString,
            let originImage = DefaultImageCache.shared.retrieveImage(forKey: origin) else {
                return nil
        }
        return originImage
    }
    
    var thumbnailCachedImage: UIImage? {
        guard let thumbnail = thumbnailURL?.absoluteString,
            let thumbnailImage = DefaultImageCache.shared.retrieveImage(forKey: thumbnail) else {
                return nil
        }
        return thumbnailImage
    }
    
}

public class RemoteImageViewerController: ImageViewerController {
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.hidesWhenStopped = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    public var remoteImage: RemoteImage?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        loadingView.snp.updateConstraints {
            $0.width.height.equalTo(40)
            $0.centerX.centerY.equalToSuperview()
        }
        loadRemoteImage()
    }
    
    private func loadRemoteImage() {
        if let originCachedImage = remoteImage?.originCachedImage {
            image = originCachedImage
        } else {
            if let thumbnailCachedImage = remoteImage?.thumbnailCachedImage {
                image = thumbnailCachedImage
            } else if let thumbnailURL = remoteImage?.thumbnailURL {
                DefaultImageDownloader.shared.donwloadImage(with: thumbnailURL, success: { [weak self] (image) in
                    guard let `self` = self,
                        self.image == nil else {return}
                    self.image = image
                })
            }
            
            loadingView.startAnimating()
            if let originURL = remoteImage?.originURL {
                DefaultImageDownloader.shared.donwloadImage(with: originURL, success: { [weak self] (image) in
                    guard let `self` = self else { return }
                    self.image = image
                    self.loadingView.stopAnimating()
                })
            }
        }
    }
}


