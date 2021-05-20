//
//  SWHelper.swift
//  ShirwindLive
//
//  Created by cedar on 2021/5/4.
//  Copyright © 2021 live. All rights reserved.
//

import UIKit
import HyphenateChat
import EaseIMKit

class SWHelper: NSObject{
    static let shared = SWHelper()
    
    override init() {
        super.init()
        self.initHelper()
    }
    
    func initHelper() {
        EMClient.shared()?.add(self, delegateQueue: nil)
        EMClient.shared()?.contactManager.add(self, delegateQueue: nil)
        EMClient.shared()?.groupManager.add(self, delegateQueue: nil)
        EMClient.shared()?.chatManager.add(self, delegateQueue: nil)
        //
        NotificationCenter.default.addObserver(self, selector: #selector(handlePushChatController(anotif:)), name: NSNotification.Name(rawValue: CHAT_PUSHVIEWCONTROLLER), object: nil)

    }
}

    
    //网络变化
extension SWHelper:EMClientDelegate {
    func connectionStateDidChange(_ aConnectionState: EMConnectionState) {
        if aConnectionState == EMConnectionDisconnected {
            //✨想要获取当前的topVC 来使用alertViewController
            let alert = EMAlertView(title: "当前处于离线状态了😢", message: "")
            alert.show()
        }
    }
    func userAccountDidLoginFromOtherDevice() {
        let alert = EMAlertView(title: "账号在其他地方登了😢", message: "")
        alert.show()
    }
    func userAccountDidRemoveFromServer() {
        let alert = EMAlertView(title: "你被禁止登入了😢", message: "")
        alert.show()
    }
    
}

//
extension SWHelper:EMChatManagerDelegate {

    func messagesDidReceive(_ aMessages: [Any]!) {
        print("收到消息了～～哈哈")
    }
}

extension SWHelper:EMGroupManagerDelegate {
    func didJoin(_ aGroup: EMGroup!, inviter aInviter: String!, message aMessage: String!) {
        
    }
}

extension SWHelper:EMContactManagerDelegate{
    
}

extension SWHelper {
    @objc
    func handlePushChatController(anotif:Notification) {
        let obj = anotif.object
        var type: EMConversationType = EMConversationTypeChat
        var conversationId = ""
        if let obj = obj as? String {
            conversationId = obj
            type = EMConversationTypeChat
        } else if let obj = obj as? EMGroup {
            conversationId = obj.groupId
            type = EMConversationTypeGroupChat
        } else if let obj = obj as? EMChatroom {
            conversationId = obj.chatroomId
            type = EMConversationTypeChat
        } else if let obj = obj as? EaseConversationModel {
            conversationId = obj.easeId
            type = obj.type
        }
        let vc = SWMessageChatViewController.initWithConversationId(conversationId, conversationType: type, chatViewModel: EaseChatViewModel())
        let topVC = UIApplication.getTopViewController()
        if let nav = topVC?.navigationController as? UINavigationController {
            nav.pushViewController(vc, animated: true)
        } else {
            print("断点")
        }
        print("但是没有弹出窗口哈哈")
    }


}
