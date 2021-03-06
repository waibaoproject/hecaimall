//
//  PayInfo.swift
//  Mall
//
//  Created by 王小涛 on 2017/11/5.
//  Copyright © 2017年 王小涛. All rights reserved.
//

import Unbox
import GearNetwork

struct AliPayInfo: Unboxable {
    let orderInfo: String
    
    init(unboxer: Unboxer) throws {
        orderInfo = unboxer.unbox(key: "order_info") ?? ""
    }
}

extension AliPayInfo: Modelable {}


struct WechatPayInfo: Unboxable {
    let partnerId: String
    let prepayId: String
    let package: String
    let nonceStr: String
    let timeStamp: UInt32
    let sign: String
    
    init(unboxer: Unboxer) throws {
        partnerId = unboxer.unbox(key: "partner_id") ?? ""
        prepayId = unboxer.unbox(key: "prepay_id") ?? ""
        package = unboxer.unbox(key: "package") ?? ""
        nonceStr = unboxer.unbox(key: "nonce_str") ?? ""
        timeStamp = unboxer.unbox(key: "time_stamp") ?? 0
        sign = unboxer.unbox(key: "sign") ?? ""
    }
}

extension WechatPayInfo: Modelable {}


func askForPayWay(aliPay: @escaping ()->Void, wechatPay: @escaping ()->Void, cancel: @escaping () -> Void) {
    let controller = UIAlertController(title: "请选择支付方式", message: nil, preferredStyle: .actionSheet)
    let action1 = UIAlertAction(title: "支付宝支付", style: .default) { _ in
        aliPay()
    }
    let action2 = UIAlertAction(title: "微信支付", style: .default) { _ in
        wechatPay()
    }
    let action3 = UIAlertAction(title: "取消", style: .cancel) { _ in
        cancel()
    }
    controller.addAction(action1)
    controller.addAction(action2)
    controller.addAction(action3)
    UIViewController.topMost!.present(controller, animated: true, completion: nil)
}

func apiPay(info: AliPayInfo, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
    
    //RESERVER
    //此处的模板为 观赛日支付模板
    let req = PaymentManagers.AlipayRequest(urlString : info.orderInfo, scheme: "hecaimall")
    let order = PaymentManagers.Order.alipay(req: req)
    
    PaymentManagers.deliver(order, completionHandler: { result in
        switch result {
        case .success:
            success()
        case .error(let error):
            failure(error.reson)
        }
    })
}

func wechatPay(info: WechatPayInfo, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
    //RESERVER
    let req = PaymentManagers.WechatPayRequest(
        partnerId: info.partnerId,
        prepayId: info.prepayId,
        nonceStr: info.nonceStr,
        timeStamp: info.timeStamp,
        package: info.package,
        sign: info.sign
    )
    let order = PaymentManagers.Order.weChat(req: req)
    
    PaymentManagers.deliver(order) { (result) in
        switch result {
        case .success:
            success()
        case .error(let error):
            failure(error.reson)
        }
    }
}
