//
//  Namespacing.swift
//  Pods
//
//  Created by 王小涛 on 2017/8/23.
//
//

import Foundation

public struct WebImage<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol WebImageCompatible {
    associatedtype WebImageCompatibleType
    var web: WebImageCompatibleType { get }
}

public extension WebImageCompatible {
    public var web: WebImage<Self> {
        get { return WebImage(self) }
    }
}

extension UIImageView: WebImageCompatible {}
extension UIButton: WebImageCompatible {}
