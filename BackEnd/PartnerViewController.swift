//
//  PartnerViewController.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/4.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SegmentedControl
import WebImage

class PartnerViewController: UIViewController, FromBackendStoryboard {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!

    @IBOutlet weak var segmentedControl: SegmentedControl! {
        didSet {
                segmentedControl.tintColor = .clear
                segmentedControl.items = ["APP二维码", "微信二维码"]
                
                let normalColor = UIColor(hex: 0x595757)!
                let selectedColor = UIColor(hex: 0xD22222)!
                
                segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: normalColor], for: .normal)
                segmentedControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: selectedColor], for: .selected)
                
                segmentedControl.segmentBackgroundView = {
                    Slider(isSelected: $0, color: selectedColor, size: CGSize(width: 0, height: 2))
                }
                
                segmentedControl.didSelect = { [unowned self] in
                    self.qrCodeImageView.web.setImage(with: $0 == 0 ? self.partner?.appQrCode: self.partner?.wechatQrCode)
                }
        }
    }
    
    var partner: Partner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.web.setImage(with: partner?.icon)
        nameLabel.text = partner?.name
        typeLabel.text = partner?.type
        qrCodeImageView.web.setImage(with: partner?.appQrCode)
    }
}
