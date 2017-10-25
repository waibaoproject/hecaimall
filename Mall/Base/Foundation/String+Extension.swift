//
//  String+Extension.swift
//  Mall
//
//  Created by 王小涛 on 2017/9/28.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isNilOrBlankString: Bool {
        switch self {
        case .none:
            return true
        case let .some(wrapped):
            return wrapped.isBlankString
        }
    }
}

extension String {
    
    var length: Int {
        return (self as NSString).length
    }
    
    var isBlankString: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
