//
//  DatePickerView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/12.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SnapKit


class DatePickerView: UIView, AsPicker {

    private lazy var confirmButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle("确定", for: .normal)
        button.setTitleColor(.red, for: .normal)
        self.addSubview(button)
        button.snp.updateConstraints({
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(15)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        })
        button.addTarget(self, action: #selector(clickConformButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var picker: UIDatePicker = { [unowned self] in
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        self.addSubview(picker)
        picker.snp.updateConstraints({
            $0.top.equalTo(self.confirmButton.snp.bottom).offset(15)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        })
        self.backgroundColor = .white
        return picker
    }()
    
    var currentDate: Date? {
        get {
            return picker.date
        }
        set {
            picker.setDate(newValue ?? Date().addingYears(-18), animated: true)
        }
    }
    
    var didConfirm: ((Date) -> Void)?
    
    @objc func clickConformButton(sender: Any) {
        didConfirm?(currentDate!)
    }
}
