//
//  ShareSelectionView.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/22.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import FoundationExtension

struct ShareItem {
    let socialPlatform: SocialPlatform
    let shareImage: UIImage
    let shareTitle: String
    
}

class ShareSelectionView: UIView, AsPicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        getSharePlatform()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var shareMessage: WebpageSocialMessage?
    
    fileprivate var shareItems: [ShareItem] = []
    
    func viewHeight() -> CGFloat {
        let count = shareItems.count / 4 + (shareItems.count % 4 == 0 ? 0 : 1)
        return ShareItemCell.cellSize.height * CGFloat(count) + 44 + 0.5
    }
    
    private lazy var collectionView: UICollectionView = { [unowned self] in
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.white
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = false
        view.register(cellType: ShareItemCell.self)
        self.addSubview(view)
        return view
        }()
    
    lazy var lineView: UIView = { [unowned self] in
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.addSubview(view)
        return view
        }()
    
    lazy var cancelButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle("取消", for: UIControlState.normal)
        button.setTitleColor(UIColor(hex: 0x555555), for: UIControlState.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor(hex: 0xF4F4F4)
        button.addTarget(self, action: #selector(clickCancelButton), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
        return button
        }()
    
    override func updateConstraints() {
        var padding: CGFloat = 0
        if shareItems.count == 1 {
            padding = (UIScreen.main.bounds.width - ShareItemCell.cellSize.width) / 2
        } else if shareItems.count == 2 {
            padding = (UIScreen.main.bounds.width - ShareItemCell.cellSize.width * 2 - 16) / 2
        } else if shareItems.count == 3 {
            padding = (UIScreen.main.bounds.width - ShareItemCell.cellSize.width * 3 - 16 * 2) / 2
        } else {
            padding = (UIScreen.main.bounds.width - ShareItemCell.cellSize.width * 4 - 16 * 3) / 2
        }
        
        collectionView.snp.updateConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(padding)
            $0.right.equalToSuperview().offset(-padding)
            $0.height.equalTo(ShareItemCell.cellSize.height)
        }
        
        lineView.snp.updateConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        cancelButton.snp.updateConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        super.updateConstraints()
    }
}

extension ShareSelectionView {
    @objc fileprivate func clickCancelButton() {
        dismiss()
    }
    
    func getSharePlatform() {
        var platformTypeArray = UMSocialManager.default().platformTypeArray.map({
            return String(describing: $0)
        }).map({
            return Int($0)
        })
        
        guard !platformTypeArray.isEmpty else {
            return
        }
        
        guard platformTypeArray.count > 1 else {
            setupShareItems(platformTypeArray)
            return
        }
        
        platformTypeArray = platformTypeArray.sorted(by: { (item0, item1) -> Bool in
            item0! < item1!
        })
        setupShareItems(platformTypeArray)
        
    }
    
    func setupShareItems(_ platformTypeArray: [Int?]) {
        for type in platformTypeArray {
            if type == UMSocialPlatformType.sina.rawValue {
                let itemSina = ShareItem(socialPlatform: SocialPlatform.sina, shareImage: UIImage(named: "share_sina")!, shareTitle: "新浪微博")
                shareItems.append(itemSina)
            } else if type == UMSocialPlatformType.wechatSession.rawValue {
                let itemWeChatSession = ShareItem(socialPlatform: SocialPlatform.wechatSession, shareImage: UIImage(named: "share_wechat_session")!, shareTitle: "微信")
                shareItems.append(itemWeChatSession)
            } else if type == UMSocialPlatformType.wechatTimeLine.rawValue {
                let itemWeChatTimeLine = ShareItem(socialPlatform: SocialPlatform.wechatTimeline, shareImage: UIImage(named: "share_wechat_timeline")!, shareTitle: "朋友圈")
                shareItems.append(itemWeChatTimeLine)
            } else if type == UMSocialPlatformType.QQ.rawValue {
                let itemQQ = ShareItem(socialPlatform: SocialPlatform.qq, shareImage: UIImage(named: "share_qq")!, shareTitle: "qq")
                shareItems.append(itemQQ)
                
//                let itemQzone = ShareItem(socialPlatform: SocialPlatform.qzone, shareImage: UIImage(named: "share_qzone")!, shareTitle: "qzone")
//                shareItems.append(itemQzone)

            }
        }
    }
}

extension ShareSelectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ShareItemCell
        cell.shareItem = shareItems[indexPath.row]
        return cell
    }
}

extension ShareSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ShareItemCell.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let entity = shareMessage, let controller = UIViewController.topMost else {
            return
        }
        dismiss()
        let shareItem = shareItems[indexPath.row]
        ShareManager.shared.sharedImageAndText(platformType: shareItem.socialPlatform.asUMSocialPlatformType, entity: entity, in: controller)
        
    }
}

class ShareItemCell: UICollectionViewCell, Reusable {
    
    static let cellSize = CGSize(width: 60, height: 112)
    
    lazy var shareImageView: UIImageView = { [unowned self] in
        let imageView = UIImageView()
        self.addSubview(imageView)
        imageView.snp.updateConstraints({
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(60)
        })
        return imageView
        }()
    
    lazy var shareTitleLabel: UILabel = { [unowned self] in
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.center
        self.addSubview(label)
        label.snp.updateConstraints({
            $0.top.equalTo(self.shareImageView.snp.bottom).offset(8)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        })
        
        return label
        }()
    
    var shareItem: ShareItem? {
        didSet {
            shareImageView.image = shareItem?.shareImage
            shareTitleLabel.text = shareItem?.shareTitle
        }
    }
}
