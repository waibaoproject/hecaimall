////
////  ShareManager.swift
////  Mall
////
////  Created by 王小涛 on 2017/11/6.
////  Copyright © 2017年 王小涛. All rights reserved.
////
//
import Foundation

enum SocialPlatform {
    case wechatSession
    case wechatTimeline
    case qq
    case sina
    case qzone

    var asUMSocialPlatformType: UMSocialPlatformType {
        switch self {
        case .wechatSession:
            return .wechatSession
        case .wechatTimeline:
            return .wechatTimeLine
        case .qq:
            return .QQ
        case .sina:
            return .sina
        case .qzone:
            return .qzone
        }
    }

}

struct WebpageSocialMessage {

    let title: String?
    let text: String?
    let thumbnail: String?
    let url: String?

    init(title: String? = nil,
         text: String? = nil,
         thumbnail: String? = nil,
         url: String?) {

        self.title = title
        self.text = text
        self.thumbnail = thumbnail
        self.url = url
    }
}


class ShareManager {

    static let shared = ShareManager()

    private init() {}

    func share(entity: WebpageSocialMessage, `in` controller: UIViewController) {

//        let view = ShareSelectionView()
//        view.shareMessage = entity
//        view.showAsPicker(height: view.viewHeight())
        
        
        let toRemoves: [UMSocialPlatformType] = [.wechatFavorite, .yixinTimeLine, .sms]
        let toRemovesForOC = toRemoves.map { NSNumber(integerLiteral: $0.rawValue) }
        UMSocialManager.default().removePlatformProvider(withPlatformTypes: toRemovesForOC)
        UMSocialUIManager.showShareMenuViewInWindow { [weak self] (platformType, _) in
            guard let `self` = self else {return}
            self.sharedImageAndText(platformType: platformType, entity: entity, in: controller)
        }
    }

    func sharedImageAndText(platformType: UMSocialPlatformType, entity: WebpageSocialMessage, `in` controller: UIViewController) {
        let messageObject = UMSocialMessageObject()
        if platformType == .sina {
            let messageText = [entity.text, entity.url].flatMap{$0}.joined(separator: " ")
            let  shareObject = UMShareImageObject()
            shareObject.shareImage = entity.thumbnail
            messageObject.text = messageText
            messageObject.shareObject = shareObject
        } else {
            let sharedObject = UMShareWebpageObject.shareObject(withTitle: entity.title, descr: entity.text, thumImage: entity.thumbnail)
            sharedObject?.webpageUrl = entity.url
            messageObject.shareObject = sharedObject
        }

        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: controller) { [weak self] (data, error) in
            if error != nil {
                print("error---\(error.debugDescription)")
            } else {
                if data is UMSocialShareResponse {
                    let response: UMSocialShareResponse = data as! UMSocialShareResponse
                    print("response message is \(response)")
                } else {
                    print("response data is \(data ?? "")")
                }
            }
            self?.alertWithError(error: error, in: controller)
        }
    }

    func alertWithError(error: Error?, `in` controller: UIViewController) {
        let result: String = {
            if error == nil {
                return "分享成功"
            } else {
                return "分享失败"
            }
        }()
        let alertController = UIAlertController(title: "分享", message: result, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            (UIAlertAction) -> Void in
            print(result)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}

