//
//  RecommandProductCell.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/1.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import Reusable
import RxSwift

class RecommandProductCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    var product: Product? {
        didSet {
            coverImageView.web.setImage(with: product?.cover)
            nameLabel.text = product?.name
            typeLabel.text = ["类型: ", product?.type].flatMap { $0 }.joined()
            priceLabel.text = product?.price.display
            salesLabel.text = "月销\(product?.salesCount ?? 0)笔"
        }
    }
    
    var didClickAddToCartSuccess: (() -> Void)?
    
    static func cellSize(collectionView: UICollectionView) -> CGSize {
        let width = (collectionView.bounds.width - 45) / 2
        let height = 15 + (width - 30) + 5 + 15 + 5 + 15 + 5 + 15 + 10
        return CGSize(width: width, height: height)
    }
    
    @IBAction func clickAddToCartButton(sender: Any) {
        guard let productId = product?.id else {return}
        parentViewController?.view.endEditing(true)

        LoginCenter.default.loginIfNeeded().flatMap({ _ in
            responseVoid(accessory: LoadingAccessory(view: self.parentViewController!.view), urlRequest: APIPath(method: .post, path: "/cart/addToCart/id/\(productId)"))
        })
            .subscribe(onNext: { [weak self] in
                self?.parentViewController?.view.toast("加入购物车成功")
                self?.didClickAddToCartSuccess?()
            })
            .disposed(by: disposeBag)
    }
}

