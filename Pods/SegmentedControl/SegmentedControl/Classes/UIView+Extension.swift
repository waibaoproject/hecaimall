//
//  UIView+Extension.swift
//  Pods
//
//  Created by 王小涛 on 2016/12/20.
//
//

import Foundation

extension UIView {
    
    func replaceSubview(at index: Int, withView view: UIView) {
        subviews[index].removeFromSuperview()
        insertSubview(view, at: index)
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
