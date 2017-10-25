//
//  OrderNoteCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/6.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import FoundationExtension

class OrderNoteCell: UITableViewCell, Reusable {
    @IBOutlet weak var noteTextView: PlaceholderTextView!
    
    var order: Order! {
        didSet {
            noteTextView.text = order.remark.isNilOrBlankString ? nil : order.remark
        }
    }
}
