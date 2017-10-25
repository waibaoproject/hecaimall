//
//  CommentCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/15.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable

class CommentCell: UITableViewCell, Reusable {

    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imagePicker: ImageShowerView!
    
    var comment: ProductComment! {
        didSet {
            nicknameLabel.text = comment.user?.nickname
            timeLabel.text = comment.createAt?.toString(by: "yyyy.MM.dd")
            contentLabel.text = comment.content
            imagePicker.images = comment.images
        }
    }
}
