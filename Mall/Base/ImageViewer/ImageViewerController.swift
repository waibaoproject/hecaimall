//
//  ImageViewerController.swift
//  Pods
//
//  Created by 王小涛 on 2017/9/8.
//
//

import AVFoundation
import SnapKit

public class ImageViewerController: UIViewController {
    
    fileprivate lazy var scrollView: UIScrollView = { [unowned self] in
        let view = UIScrollView()
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 1.0
        
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        
        view.decelerationRate = UIScrollViewDecelerationRateFast
        return view
        }()
    
    fileprivate(set) lazy var imageView: UIImageView = { [unowned self] in
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        view.isUserInteractionEnabled = true
        return view
        }()
    
    
    public var image: UIImage? {
        didSet {
            imageView.image = image
            
            if let image = imageView.image {
                let imageScale = image.size.height / image.size.width
                let imageDisplayHeight = UIScreen.main.bounds.width * imageScale
                let scale = UIScreen.main.bounds.height / imageDisplayHeight
                scrollView.maximumZoomScale = max(scale, 2.0)
                
                imageView.snp.updateConstraints {
                    $0.edges.equalToSuperview()
                    $0.width.equalTo(self.view)
                    $0.height.equalTo(max(imageDisplayHeight, UIScreen.main.bounds.height))
                }
            }
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    deinit {
        print("ImageViewerController deinit")
    }
}

extension ImageViewerController {
    
    func doubleTap(sender: UITapGestureRecognizer) {
        
        func zoom(anchorPoint: CGPoint) {
            func zoom(toScale scale: CGFloat, center: CGPoint) -> CGRect {
                
                let height = scrollView.frame.size.height / scale;
                let width  = scrollView.frame.size.width  / scale;
                let x = center.x - (width  / 2.0);
                let y = center.y - (height / 2.0);
                
                return CGRect(x: x, y: y, width: width, height: height)
            }
            
            let zoomScale: CGFloat = scrollView.zoomScale < ((scrollView.minimumZoomScale + scrollView.maximumZoomScale) / 2) ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
            let zoomRect = zoom(toScale: zoomScale, center: anchorPoint)
            scrollView.zoom(to: zoomRect, animated: true)
        }
        zoom(anchorPoint: sender.location(in: sender.view))
    }
}

extension ImageViewerController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        func adjustsScrollViewInsetsIfNeeded() {
            guard let image = imageView.image else { return }
            let imageViewSize = AVMakeRect(aspectRatio: image.size, insideRect: imageView.frame)
            let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
            let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
            scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
        }
        adjustsScrollViewInsetsIfNeeded()
    }
}
