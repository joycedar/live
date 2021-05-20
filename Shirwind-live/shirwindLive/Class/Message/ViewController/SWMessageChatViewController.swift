//
//  SWMessageChatViewController.swift
//
//  Created by cedar on 2021/5/2.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import EaseIMKit
import HyphenateChat



class SWMessageChatViewController:EaseChatViewController {

    public var conversation =  EMConversation()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override class func initWithConversationId(_ aConversationId: String, conversationType aType: EMConversationType, chatViewModel aModel: EaseChatViewModel) -> EaseChatViewController {
        super.initWithConversationId(aConversationId, conversationType: aType, chatViewModel: aModel)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SWMessageChatViewController:EaseChatViewControllerDelegate {
    
}
