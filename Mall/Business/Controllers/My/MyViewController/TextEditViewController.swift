//
//  TextEditViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit

class TextEditViewController: UIViewController, FromMyStoryboard {
    
    @IBOutlet weak var textField: UITextField!
    
    var text: String?
    
    var keyboardType: UIKeyboardType = .default
    
    var didSave: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.clearButtonMode = .whileEditing
        textField.text = text
        textField.keyboardType = keyboardType
        textField.becomeFirstResponder()
    }
    
    @IBAction func clickSaveButton(sender: Any) {
        guard let text = textField.text else {
            view.noticeOnlyText("输入不能为空")
            return
        }
        
        guard !text.isBlankString else {
            view.noticeOnlyText("输入不能为空")
            return
        }
        
        didSave?(text)
    }
}
