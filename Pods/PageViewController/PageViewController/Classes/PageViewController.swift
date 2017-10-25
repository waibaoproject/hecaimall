//
//  PageViewController.swift
//  PageViewController
//
//  Created by 王小涛 on 2017/6/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation

//extension UIPageViewController {
//    
//    // bug fix for uipageview controller. see http://stackoverflow.com/questions/14220289/removing-a-view-controller-from-uipageviewcontroller
//    // 参考 http://www.jianshu.com/p/3cca93ceee96
//    open func safeSetViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, animated: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
//        
//        setViewControllers(viewControllers, direction: direction, animated: animated) { [weak self] finished in
//            
//            guard let `self` = self else {return}
//            
//            // bug fix for uipageview controller. see http://stackoverflow.com/questions/14220289/removing-a-view-controller-from-uipageviewcontroller
//            // 参考 http://www.jianshu.com/p/3cca93ceee96
//            if animated && finished {
//                DispatchQueue.main.async(execute: {
//                    self.setViewControllers(viewControllers, direction: direction, animated: false, completion: nil)
//                })
//            }
//        }
//    }
//}

public class PageViewController: UIPageViewController {
    
    private(set) var controllers: [UIViewController] = []
    
    fileprivate var previousIndexs: [Int] = [0]
    fileprivate var lastPendingIndex: Int = 0
    
    public var currentController: UIViewController? {
        guard currentIndex < controllers.count else {return nil}
        return controllers[currentIndex]
    }
    
    public var totalPages: Int {
        return controllers.count
    }
    
    public fileprivate(set) var currentIndex: Int = 0 {
        didSet {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = (currentIndex == 0)
        }
    }
    
    public var didScrollToIndex: ((Int) -> Void)?
    
    public var isScrollEnabled: Bool = true {
        didSet {
            view.subviews.flatMap({ $0 as? UIScrollView}).forEach({$0.isScrollEnabled = isScrollEnabled})
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
    
    public convenience init(controllers: [UIViewController], interPageSpacing: CGFloat = 0.0) {
        self.init(transitionStyle: .scroll,
                  navigationOrientation: .horizontal,
                  options: [UIPageViewControllerOptionInterPageSpacingKey: interPageSpacing])
        
        self.controllers = controllers
        
        hidesBottomBarWhenPushed = true
        
        if let controller = controllers.first {
            
            setViewControllers([controller],
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
    }
    
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.dataSource = self
        self.delegate = self
    }
    
    public func scrollToIndex(index: Int, animated: Bool = true) {
        
        guard index >= 0 && index < controllers.count else {return}
        
        let direction: UIPageViewControllerNavigationDirection = {
            if index < currentIndex  {
                return .reverse
            } else {
                return .forward
            }
        }()
        
        let controller = controllers[index]
        setViewControllers([controller], direction: direction, animated: animated)
        
        currentIndex = index
    }
    
    public func removeCurrentController(animated: Bool = true) {
        
        guard currentController != nil else {return}

        if currentIndex < controllers.count - 1 { // 当前页面不是最后面的一个
            
            let controller = controllers[currentIndex+1]
            setViewControllers([controller], direction: .forward, animated: animated)
            
            controllers.remove(at: currentIndex)
            
        } else { // 当前页面是最后面的一个
            
            if currentIndex > 0 {
                
                let controller = controllers[currentIndex-1]
                setViewControllers([controller], direction: .reverse, animated: animated)
                
                controllers.remove(at: currentIndex)
                currentIndex = currentIndex - 1
                
            } else  {
                
                print("最后一个controller不能直接被remove")
            }
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.index(of: viewController), index > 0 else {
            return nil
        }
        
        return controllers[index-1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.index(of: viewController), index < controllers.count-1 else {
            return nil
        }
        
        return controllers[index+1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let lastPendingController = pendingViewControllers.first else {return}
        guard let index = controllers.index(of: lastPendingController) else {return}
        lastPendingIndex = index
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {return}
        guard let previousController = previousViewControllers.first else {return}
        guard let previousIndex = controllers.index(of: previousController) else {return}
        previousIndexs.append(previousIndex)
        
        // 这种情况是，当你在一个页面上，快速往左滑动然后又往右滑动时，会产生。此时
        // func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController])
        // 只会调用一次
        if previousIndex == lastPendingIndex {
            currentIndex = previousIndexs[previousIndexs.count-2]
        } else {
            currentIndex = lastPendingIndex
            didScrollToIndex?(currentIndex)
        }
    }
}
