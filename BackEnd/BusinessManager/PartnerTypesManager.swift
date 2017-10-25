//
//  PartnerTypesManager.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/24.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import RxSwift

class PartnerTypesManager {
    
    static let shared = PartnerTypesManager()
    
    private let disposeBag = DisposeBag()
    
    var items: [PartnerType] = []
    
    private init() {
        let api = APIPath(path: "/partner/types")
        DefaultArrayDataSource(api: api).response(accessory: nil).subscribe(onNext: { (data: [PartnerType]) in
            self.items = data
        })
        .disposed(by: disposeBag)
    }
}
