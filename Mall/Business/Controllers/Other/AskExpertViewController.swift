//
//  AskExpertViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class AskExpertViewController: UIViewController, FromOtherStroyboard {
    
    @IBOutlet weak var textView: PlaceholderTextView!

    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.keyboardDismissMode = .onDrag
    }

    @IBAction func clickSubmitButton(sender: Any) {
        guard let text = textView.text, !text.isBlankString else {
            view.noticeOnlyText("请输入问题，不能空白")
            return
        }
        let api = APIPath(method: .post, path: "/user/questions", parameters: ["ask": text])
        let loading = LoadingAccessory(view: view)
        DefaultDataSource(api: api).response(accessory: loading)
            .subscribe(onNext: {[weak self] (data: Question) in
                self?.view.noticeOnlyText("提交成功")
                self?.textView.text = nil
            })
        .disposed(by: disposeBag)
    }
}
