////
////  NavigationBar.swift
////  Kouclo-live
////
////  Created by cedar on 2021/4/5.
////  Copyright © 2021 live. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SnapKit
//protocol shirwindBottomBarDeleagete {
//    func clickCameraButton()
//}
//@available(iOS 9.0, *)
//class shirWindBottomBar:UITabBar {
//    var delegate:shirwindBottomBarDeleagete?
//    private var homeTabButton: UITabBar = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "home"), for: .normal)
//        button.setTitle("首页", for: .normal)
//        button.frame.size = CGSize(width: 30, height: 30)
//        return button
//    }()
//    
//    private var subScribeTabButton: UITabBar = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "subscribe"), for: .normal)
//        button.setTitle("关注", for: .normal)
//        button.frame.size = CGSize(width: 30, height: 30)
//        return button
//    }()
//    
//    private var messageTabButton: UITabBar = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "messgae"), for: .normal)
//        button.setTitle("消息", for: .normal)
//        button.frame.size = CGSize(width: 30, height: 30)
//        return button
//    }()
//    
//    private var meTabButton: UITabBar = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "me"), for: .normal)
//        button.setTitle("我", for: .normal)
//        button.frame.size = CGSize(width: 30, height: 30)
//        return button
//    }()
//    
//    
//    lazy var cameraButton:UIButton = {
//        let btn = UIButton(type: .custom)
//        btn.setImage(UIImage(named: "tab_launch"), for: .normal)
//        btn.addTarget(self, action: #selector(cameraButtonClick), for: .touchUpInside)
//        btn.frame.size = CGSize(width: 30, height: 30)
//        return btn
//    }()
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.alignment = .fill
//        self.axis = .horizontal
//        self.distribution = .fillEqually
//        self.spacing = 10
//        self.addArrangedSubview(homeTabButton)
//        self.addArrangedSubview(subScribeTabButton)
//        self.addSubview(messageTabButton)
//        self.addSubview(meTabButton)
//        
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc
//    func cameraButtonClick(){
//        self.delegate?.clickCameraButton()
//       // self.present(KKLMyLiveViewController(), animated: true) {}
//    }
//}
