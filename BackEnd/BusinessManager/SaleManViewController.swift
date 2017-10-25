//
//  SaleManViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import RxSwift
import FoundationExtension

class SaleManViewController: UITableViewController, FromBackendStoryboard {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    var saleMan: Salesman?

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.text = saleMan?.name
        phoneTextField.text = saleMan?.phone
        companyTextField.text = saleMan?.distributors
        qrCodeImageView.web.setImage(with: saleMan?.qrCodeUrl) 
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
}
