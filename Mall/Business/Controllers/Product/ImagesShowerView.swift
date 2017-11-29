//
//  ImageShowerView.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/11.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import UIKit
import SnapKit
import Reusable

class ImageShowerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var images: [URL] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        cell.imageView.web.setImage(with: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let remoteImages = images.map {
            RemoteImage(thumbnail: $0.absoluteString, origin: $0.absoluteString)
        }
        let controller = RemoteImagesViewerController()
        controller.remoteImages = remoteImages
        parentViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}


