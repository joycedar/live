//
//  KKLPlayerViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/29.
//  Copyright © 2016年 live. All rights reserved.
//  播放视频的控制器

import UIKit
import IJKMediaFramework

class KKLPlayerViewController: UIViewController {
    var cctvLive:SWCCTVModel?
    var userLive:SWRoomModel?
    
    var player:IJKMediaPlayback?
    var watchingRoomViewController:KKLLiveViewController = KKLLiveViewController()
    var blurImageView:UIImageView = UIImageView()
    var closeBtn:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "room_close_button"), for: .normal)
        btn.frame = CGRect(x: UIScreen.main.bounds.width - 87 - 10,
                           y: UIScreen.main.bounds.height - 87 - 10,
                           width: 87,
                           height: 87)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.blurImageView.frame = self.view.bounds
        self.blurImageView.isUserInteractionEnabled = true
        self.view.addSubview(self.blurImageView)
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.blurImageView.bounds
        self.blurImageView.addSubview(blurView)
        
        //play的位置
        self.player = IJKFFMoviePlayerController(contentURLString: cctvLive?.url == nil ? userLive?.roomUrl : cctvLive?.url,
                                                 with: IJKFFOptions.byDefault())
        self.player?.prepareToPlay()
        self.player?.shouldAutoplay = true
        if let view = self.player?.view{
            self.view.addSubview(view)
        }
        var safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20
        self.player?.view.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview()
        })
        
        self.addChild(watchingRoomViewController)
        self.view.addSubview(watchingRoomViewController.view)
        self.watchingRoomViewController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: safeTop, left: 0, bottom: 0, right: 0))
        }
        self.watchingRoomViewController.cctvLive = cctvLive
        self.watchingRoomViewController.userLive = userLive
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.installMovieNotificationObservers()

        let window = UIApplication.shared.delegate?.window //这时候的window是
        window??.addSubview(self.closeBtn)
        closeBtn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.player?.shutdown()
        self.removeMovieNotificationObservers()
        self.closeBtn.removeFromSuperview()
    }
    
    
    //MARK:- Pragma mark Install Movie Notifications
    private func installMovieNotificationObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
         NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackDidFinish(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(mediaIsPreparedToPlayDidChange(notification:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }

    
    ///关闭按钮
    @objc
    func closeBtnClick(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    ///移除所有添加的通知
    private func removeMovieNotificationObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    
    //MARK: NSNotification监听方法
    @objc
    func loadStateDidChange(notification:Notification){
        self.blurImageView.isHidden = true
        self.blurImageView.removeFromSuperview()
        print("可能是失败的")
    }
    
    @objc
    func moviePlayBackDidFinish(notification:Notification){
        print("来啦～")
    }
    
    @objc
    func mediaIsPreparedToPlayDidChange(notification:Notification){
        print("正在准备中，等等～")
    }
    
    @objc
    func moviePlayBackStateDidChange(notification:Notification){
        print("网络环境发生变化")
    }
    
}
