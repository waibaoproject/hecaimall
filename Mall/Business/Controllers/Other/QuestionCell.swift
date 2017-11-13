//
//  QuestionCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/14.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import FoundationExtension

class QuestionCell: UITableViewCell, Reusable {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var question: Question! {
        didSet {
            nicknameLabel.text = question.asker?.nickname
            timeLabel.text = ["时间:", question.createAt?.toString(by: "yyyy-MM-dd HH:mm:ss")].flatMap({ $0 }).joined(separator: " ")
            askLabel.text = question.ask
            let answer: NSAttributedString? = {
                if question.answer.isNilOrBlankString {
                    return nil
                } else {
                    let text1 = NSMutableAttributedString(string: "专家回复: ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
                    let text2 = NSAttributedString(string: question.answer ?? "")
                    text1.append(text2)
                    return text1
                }
            }()
            answerLabel.attributedText = answer
        }
    }
    
    static func cellHeight(tableView: UITableView, question: Question!) -> CGFloat {
        let width = tableView.bounds.width - 60.0
        let size = CGSize(width: width, height: 999)
        let askHeight = (question.ask as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil).height
        
        
        let answerHeight: CGFloat = {
            if question.answer.isNilOrBlankString {
                return 0
            } else {
                let answer = "专家回复: \(question.answer ?? "")"
                return (answer as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], context: nil).height
            }
        }()
        
        return 40 + 2 + 15 + askHeight + 15 + answerHeight + 15
    }
}
