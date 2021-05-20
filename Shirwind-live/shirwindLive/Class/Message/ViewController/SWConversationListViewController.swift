//
//  ShirWindMessageViewController.swift
//
//  Created by cedar on 2021/4/5.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import EaseIMKit
import HyphenateChat


class SWConversationListViewController:UIViewController  {
    let conversationList = [Any]()
    let viewModel = EaseConversationViewModel()
    let conversationViewController: EaseConversationsViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel.canRefresh = true
        viewModel.badgeLabelPosition = .avatarTopRight
        conversationViewController = EaseConversationsViewController(model: viewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        guard let conversationViewController = conversationViewController else {
            return
        }
        self.view.addSubview(conversationViewController.view)
        var safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20
        var safeBottom = 44 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        conversationViewController.view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(44 + safeTop)
            make.bottom.equalToSuperview().offset(-safeBottom)
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        conversationViewController.delegate = self
    }
    func refreshTableVew() {
        DispatchQueue.main.async {
            if self.view.window != nil {
                self.conversationViewController?.refreshTable()
            }
        }
    }
    func refreshTableViewWithData() {
        EMClient.shared()?.chatManager .getConversationsFromServer({[weak self] (conversations, error) in
            if error == nil,
                let conversations = conversations {
                    self?.conversationViewController?.dataAry.removeAllObjects()
                    self?.conversationViewController?.dataAry.addObjects(from: conversations)
                    self?.conversationViewController?.refreshTable()
            } else {
                print("出错了")
            }
        })
    }
    
    
}


extension SWConversationListViewController:EaseConversationsViewControllerDelegate{
    func easeTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? EaseConversationCell {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHAT_PUSHVIEWCONTROLLER), object: cell.model)
        }
    }
    
}




