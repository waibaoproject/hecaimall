//
//  Slider.swift
//  Pods
//
//  Created by 王小涛 on 2016/12/20.
//
//

import Foundation

public class Slider: UIView {
    
    private let slider = UIView()
    private var sliderSize: CGSize = CGSize(width: 0, height: 2)
    
    public convenience init(isSelected: Bool, color: UIColor = UIColor(red: 1.0, green: 0.4, blue: 0.6, alpha: 1), size: CGSize = CGSize(width: 0, height: 2)) {
        self.init()
        addSubview(slider)
        slider.backgroundColor = color
        sliderSize = size
        slider.isHidden = !isSelected
    }
    
    public override var frame: CGRect {
        didSet {
            super.frame = frame
            let width = min(sliderSize.width < 1 ? bounds.width: sliderSize.width, bounds.width)
            let x = (bounds.width - width) / 2
            let y = bounds.height - sliderSize.height
            self.slider.frame = CGRect(x: x, y: y, width: width, height: sliderSize.height)
        }
    }
}
