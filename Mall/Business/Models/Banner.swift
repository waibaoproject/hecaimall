//
//  Banner.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation
import Unbox

struct Banner: Unboxable {
    let image: URL?
    let link: URL?
    
    init(unboxer: Unboxer) throws {
        image = unboxer.unbox(key: "image")
        link = unboxer.unbox(key: "link")
    }
}

extension Banner {
    init(image: URL?, link: URL?) {
        self.image = image
        self.link = link
    }
}

extension Banner: AsBanner {}
