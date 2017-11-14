//
//  AsPicker.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/8.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import SnapKit

class PickerView: UIView {
    
    private(set) lazy var shadowView: UIView = { [unowned self] in
        let view = UIView()
        view.backgroundColor = .black
        self.addSubview(view)
        self.sendSubview(toBack: view)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickShadowView(sender:))))
        return view
        }()
    
    private let contentViewTag = 89219
    private var contentViewHeigt: CGFloat = 0.0
    
    var isTapToDismiss: Bool = true
    
    @objc private func clickShadowView(sender: Any) {
        guard isTapToDismiss else {
            return
        }
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView.alpha = 0
            self.viewWithTag(self.contentViewTag)?.snp.updateConstraints {
                $0.bottom.equalTo(self.snp.bottom).offset(self.contentViewHeigt)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func show(contentView: UIView, height: CGFloat) {
        UIApplication.shared.keyWindow?.addSubview(self)
        snp.updateConstraints({
            $0.edges.equalToSuperview()
        })
        backgroundColor = .clear
        shadowView.alpha = 0
        
        contentView.tag = contentViewTag
        contentViewHeigt = height
        addSubview(contentView)
        contentView.snp.updateConstraints {
            $0.bottom.equalTo(self.snp.bottom).offset(height)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(height)
        }
        setNeedsLayout()
        layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.shadowView.alpha = 0.3
            contentView.snp.updateConstraints {
                $0.bottom.equalTo(self.snp.bottom)
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        })
    }
    
    override func updateConstraints() {
        shadowView.snp.updateConstraints({
            $0.edges.equalToSuperview()
        })
        super.updateConstraints()
    }
}

protocol AsPicker {
    func showAsPicker(height: CGFloat)
    func dismiss()
}

extension AsPicker where Self: UIView {
    func showAsPicker(height: CGFloat) {
        let picker = PickerView()
        picker.show(contentView: self, height: height)
    }
    func dismiss() {
        (superview as? PickerView)?.dismiss()
    }
}
