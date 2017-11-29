//
//  RemoteImagesViewerController.swift
//  Pods
//
//  Created by 王小涛 on 2017/9/11.
//
//

import PageViewController
import SnapKit

public class RemoteImagesViewerController: UIViewController {
 
    private var pageViewController: PageViewController!
    
    public var remoteImages: [RemoteImage] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let controllers: [UIViewController] = remoteImages.map {
            let controller = RemoteImageViewerController()
            controller.remoteImage = $0
            return controller
        }
        pageViewController = PageViewController(controllers: controllers, interPageSpacing: 10.0)
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
}

