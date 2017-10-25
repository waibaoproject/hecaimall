//
//  UIView+IBDesignable.swift
//  Pods
//
//  Created by 王小涛 on 2017/7/7.
//
//

// @IBDesignable crashing agent
// https://stackoverflow.com/questions/31265906/ibdesignable-crashing-agent

import UIKit

extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
