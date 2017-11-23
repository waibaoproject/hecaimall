//
//  TextEditViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    @IBAction func clickSaveButton(sender: Any) {
        
        view.endEditing(true)
        
        guard let text = textField.text else {
            view.toast("输入不能为空")
            return
        }
        
        guard !text.isBlankString else {
            view.toast("输入不能为空")
            return
        }
        
        didSave?(text)
        
    }
}
