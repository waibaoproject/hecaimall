//
//  Question.swift
//  Mall
//
//  Created by 王小涛 on 2017/10/13.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct Question: Unboxable {
    let id: String
    let createAt: Date?
    let asker: User?
    let ask: String
    let answer: String?
    
    init(unboxer: Unboxer) throws {
        id = unboxer.unbox(key: "id") ?? ""
        createAt = unboxer.unbox(key: "create_at")
        asker = unboxer.unbox(key: "asker")
        ask = unboxer.unbox(key: "ask") ?? ""
        answer = unboxer.unbox(key: "answer")
    }
}

extension Question: Modelable {}
