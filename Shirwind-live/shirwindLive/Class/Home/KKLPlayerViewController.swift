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
    ///模型
    var live:KKLLive?
    ///播放控制器
    var player:IJKMediaPlayback?
    
    //播放界面视图控制器
    var liveChatVC:KKLLiveViewController = {
        let vc = KKLLiveViewController()
        return vc
    }()
    
    //关闭按钮
    var closeBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "mg_room_btn_guan_h"), for: .normal)
        btn.sizeToFit()
        btn.frame = CGRect.init(x: UIScreen.main.bounds.width - btn.frame.width - CGFloat(10), y: UIScreen.main.bounds.height - btn.frame.height - 10, width: btn.frame.width, height: btn.frame.height)
        return btn
    }()
    
    ///毛玻璃效果图片
    var blurImageView:UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        ///注册直播需要的通知
        self.installMovieNotificationObservers()
        //准备播放
        self.player?.prepareToPlay()
        
        let win = UIApplication.shared.delegate?.window
        win??.addSubview(self.closeBtn)
        closeBtn.addTarget(self, action: #selector(KKLPlayerViewController.closeBtnClick), for: .touchUpInside)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //关直播
        self.player?.shutdown()
        self.removeMovieNotificationObservers()
        self.closeBtn.removeFromSuperview()
    }
    
    
    //MARK:初始化
    private func setup(){
        // 初始化播放控制器
        self.initPlayer()
        // 初始化毛玻璃控件
        self.initUI()
        // 添加自控制器
        self.addChildVC()
    }
    
    private func initPlayer(){
        if let live = live {
            let options = IJKFFOptions.byDefault()
            let playerVC = IJKFFMoviePlayerController.init(contentURLString: live.stream_addr, with: options)
            self.player = playerVC
            self.player?.view.frame = self.view.bounds
            self.player?.shouldAutoplay = true

            if let view = self.player?.view{
                self.view.addSubview(view)
            }
        }
    }
    
    private func initUI(){
        self.view.backgroundColor = UIColor.black
        self.blurImageView.frame = self.view.bounds
        self.blurImageView.isUserInteractionEnabled = true

        self.view.addSubview(self.blurImageView)
        
        //创建毛玻璃效果
        let blur = UIBlurEffect.init(style: .light)
        //创建毛玻璃视图
        let blurView = UIVisualEffectView.init(effect: blur)
        blurView.frame = self.blurImageView.bounds
        self.blurImageView.addSubview(blurView)
    }
    
    private func addChildVC(){
        self.addChild(liveChatVC)
        self.view.addSubview(liveChatVC.view)
        self.liveChatVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.liveChatVC.live = live
    }
    
    //MARK:- Pragma mark Install Movie Notifications
    private func installMovieNotificationObservers(){
        
        //监听网络环境，监听缓冲方法
        NotificationCenter.default.addObserver(self, selector: #selector(KKLPlayerViewController.loadStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        
        //监听直播完成回调
         NotificationCenter.default.addObserver(self, selector: #selector(KKLPlayerViewController.moviePlayBackDidFinish(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KKLPlayerViewController.mediaIsPreparedToPlayDidChange(notification:)), name: NSNotification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        
        //监听用户主动操作
        NotificationCenter.default.addObserver(self, selector: #selector(KKLPlayerViewController.moviePlayBackStateDidChange(notification:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
        
    }
    
    
    ///关闭按钮
    @objc func closeBtnClick(){
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
    @objc  func loadStateDidChange(notification:Notification){
        
        self.blurImageView.isHidden = true
        self.blurImageView.removeFromSuperview()
    }
    
    @objc func moviePlayBackDidFinish(notification:Notification){
        
        
    }
    
    @objc func mediaIsPreparedToPlayDidChange(notification:Notification){
        
        
    }
    
    @objc func moviePlayBackStateDidChange(notification:Notification){
        
        
    }
    
}
