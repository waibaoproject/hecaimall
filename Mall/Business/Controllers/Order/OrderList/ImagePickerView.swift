//
//  ImagePickerView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SnapKit
import Reusable
import DKImagePickerController

class ImagePickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var images: [UIImage] = [UIImage()]

    private lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(collectionView)
        collectionView.register(cellType: ImageCell.self)
        collectionView.snp.updateConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(images.count, 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as ImageCell
        let image = images[indexPath.row]
        if image.size == .zero {
            cell.imageView.image = UIImage(asset: .camera)
        } else {
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images[indexPath.row].size == .zero {
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos

            pickerController.maxSelectableCount = 4 - images.filter({ $0.size != .zero }).count

            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                
                assets.forEach({
                    $0.fetchFullScreenImage(true, completeBlock: { (image, info) in
                        let image = image!.wxCompress()
                        let index = self.images.count - 1
                        self.images.insert(image, at: index)
                    })
                })

                self.collectionView.reloadData()
            }
            
            parentViewController?.present(pickerController, animated: true, completion: nil)
        }
    }
}

class ImageCell: UICollectionViewCell, Reusable {
    lazy var imageView: UIImageView = { [unowned self] in
        let view = UIImageView()
        self.addSubview(view)
        view.snp.updateConstraints({
            $0.edges.equalToSuperview()
        })
        return view
    }()
}

