//
//  SplashScreenViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/8/23.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import WebImage
import UICircularProgressRing

class SplashScreenViewController: UIViewController, SplashViewControllerType {
    
    struct Splash {
        let image: () -> UIImage?
        let route: String?
        let duration: CGFloat
        
        init(image: @escaping () -> UIImage? = { nil } , route: String? = nil, duration: CGFloat = 3) {
            self.image = image
            self.route = route
            self.duration = duration
        }
    }
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var progressView: UICircularProgressRingView!
    
    
    private lazy var defaultSplashImage = UIImage(named: "default_splash")
    
    private lazy var defaultLaunchStayDuration: TimeInterval = 2.0
    
    private var progressValue: CGFloat = 0.0
    
    var route: ((_ routeUrl: URL) -> Void)?
    var skip: (() -> Void)?
    
    var splash = Splash()
    
    deinit {
        print("SplashScreenViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnSkip(sender:))))
        progressView.maxValue = splash.duration
        progressView.isHidden = true
        
        Timer.scheduledTimer(withTimeInterval: defaultLaunchStayDuration, repeats: false) { [weak self] _ in
            guard let `self` = self else {return}
            self.showSplash()
        }
    }
    
    func showSplash() {
        
        progressView.isHidden = false
        topImageView.isUserInteractionEnabled = true
        topImageView.image = splash.image() ?? defaultSplashImage
        topImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapOnSplash(sender:))))
        
        topImageView.alpha = 0
        progressView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.topImageView.alpha = 1
            self.progressView.alpha = 1
        }
        
        let timeUnit: CGFloat = 0.1
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timeUnit), repeats: true, block: { [weak self] (timer) in
            guard let `self` = self else {return}
            self.progressValue += timeUnit
            
            self.progressView.setProgress(value: self.progressValue, animationDuration: 0.1)
            
            if self.progressValue >= self.splash.duration {
                self.skip?()
            }
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func tapOnSplash(sender: Any) {
        guard let routeUrlString = splash.route,
            let routeUrl = URL(string: routeUrlString) else {
            return
        }
        route?(routeUrl)
    }
    
    @objc func tapOnSkip(sender: Any) {
        self.skip?()
    }
}
