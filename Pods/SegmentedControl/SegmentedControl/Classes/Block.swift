//
//  Block.swift
//  Pods
//
//  Created by 王小涛 on 2016/12/20.
//
//

import Foundation

public class Block: UIView {
    
    private let block: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 0.5
        return view
    }()
    
    public convenience init(selected: Bool) {
        self.init(frame: .zero)
        addSubview(block)
        if selected {
            block.layer.borderColor = UIColor(red: 1.0, green: 0.4, blue: 0.47, alpha: 1).cgColor
            block.backgroundColor = UIColor(red: 1.0, green: 0.96, blue: 0.984, alpha: 1)
        }else {
            block.layer.borderColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1).cgColor
            block.backgroundColor = .white
        }
    }
    
    public override var frame: CGRect {
        didSet {
            super.frame = frame
            block.frame = CGRect(x: 0, y: (self.bounds.height - 30) / 2, width: self.bounds.width, height: 30)
        }
    }
}
