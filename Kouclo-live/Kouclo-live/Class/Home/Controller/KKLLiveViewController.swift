//
//  LiveModelViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/29.
//  Copyright © 2016年 live. All rights reserved.
//  视频播放界面

import UIKit
import YYKit
import SnapKit
class LiveModelViewController: UIViewController {

    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var peopleCountL: UILabel!
    @IBOutlet weak var shareButton: UIImageView!
    
    var timer:Timer?
    ///弹幕的View
    var barrageView:KKLBarrageView?
    ///模型
    var live:LiveModel?{
        didSet{
            let imageUrl = IMAGE_HOST + (live?.creator?.portrait)!
            self.iconView.downloadImage(url: imageUrl, placeholderImageName: KKLPlaceholderImageName)
            if let users = live?.online_users{
                self.peopleCountL.text = "\(users)"
            }else{
                self.peopleCountL.text = "0"
            }
            self.peopleCountL.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.iconView.layer.cornerRadius = 15
        self.iconView.layer.masksToBounds = true
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: YYWeakProxy(target: self), selector: #selector(loveAnimate), userInfo: nil, repeats: true)
        //添加弹幕的View
        let barrageView = KKLBarrageView(frame: CGRect(x: 0, y: 100, width: KKLScreenWidth, height: 150))
        self.view.addSubview(barrageView)
        self.barrageView = barrageView
    }
    
    @objc
    func loveAnimate() {
        self.showLoveAnimate(fromView: self.shareButton, addToView: self.view)
    }
    ///心形动画
    func showLoveAnimate(fromView:UIView,addToView:UIView){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        let loveFrame = fromView.convert(fromView.frame, to:addToView)
        let positon = CGPoint.init(x: fromView.layer.position.x, y: loveFrame.origin.y - 30)
        imageView.layer.position = positon
        let imgArray = ["heart_1","heart_2","heart_3","heart_4","heart_5","heart_1"]
        let imgIndex:Int = Int(arc4random()%6)
        print(imgArray[imgIndex])
        imageView.image = UIImage(named: imgArray[imgIndex])
        addToView.addSubview(imageView)
        
        imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: { 
            imageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let duration = 3 + Int(arc4random()%5)
        let positionAnimate = CAKeyframeAnimation(keyPath: "position")
        positionAnimate.repeatCount = 1
        positionAnimate.duration = CFTimeInterval(duration)
        positionAnimate.fillMode = CAMediaTimingFillMode.forwards
        positionAnimate.isRemovedOnCompletion = false
        
        let sPatch = UIBezierPath()
        sPatch.move(to: positon)
        let sign = CGFloat(arc4random()%2 == 1 ? 1 : -1)
        let controlPointValue = CGFloat(arc4random()%50 + arc4random()%100) * sign
        sPatch.addCurve(to: CGPoint(x: positon.x, y: positon.y - 300), controlPoint1: CGPoint.init(x: positon.x - controlPointValue, y: positon.y - 150), controlPoint2: CGPoint.init(x: positon.x + controlPointValue, y: positon.y - 150))
        positionAnimate.path = sPatch.cgPath
        imageView.layer.add(positionAnimate, forKey: "heartAnimated")
        
        UIView.animate(withDuration: TimeInterval(duration), animations: { 
            imageView.layer.opacity = 0
        }) { (bool) in
            imageView.removeFromSuperview()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        barrageView?.timer?.invalidate()
        barrageView?.timer = nil
        self.barrageView?.removeFromSuperview()
        print("释放")
    }
}


class CCTVLiveViewController: UIViewController {

    ///弹幕的View
    var barrageView = KKLBarrageView()
    var peopleCountLabel = UILabel()
    var timer:Timer?
    var liveModel = CCTVModel()
    
    
    public func configWithLiveModel(liveModel:CCTVModel){
        self.liveModel = liveModel
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: YYWeakProxy(target: self), selector: #selector(loveAnimate), userInfo: nil, repeats: true)
        //添加弹幕的View
        self.barrageView = KKLBarrageView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 150))
        self.view.addSubview(barrageView)
        self.view.addSubview(peopleCountLabel)
        peopleCountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(20)
        }
    }
    
    @objc
    func loveAnimate() {
        self.showLoveAnimate(fromView: self.peopleCountLabel, addToView: self.view)
    }
    ///心形动画
    func showLoveAnimate(fromView:UIView,addToView:UIView){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        let loveFrame = fromView.convert(fromView.frame, to:addToView)
        let positon = CGPoint.init(x: fromView.layer.position.x, y: loveFrame.origin.y - 30)
        imageView.layer.position = positon
        let imgArray = ["heart_1","heart_2","heart_3","heart_4","heart_5","heart_1"]
        let imgIndex:Int = Int(arc4random()%6)
        print(imgArray[imgIndex])
        imageView.image = UIImage(named: imgArray[imgIndex])
        addToView.addSubview(imageView)
        
        imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIView.AnimationOptions.curveEaseOut, animations: {
            imageView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        let duration = 3 + Int(arc4random()%5)
        let positionAnimate = CAKeyframeAnimation(keyPath: "position")
        positionAnimate.repeatCount = 1
        positionAnimate.duration = CFTimeInterval(duration)
        positionAnimate.fillMode = CAMediaTimingFillMode.forwards
        positionAnimate.isRemovedOnCompletion = false
        
        let sPatch = UIBezierPath()
        sPatch.move(to: positon)
        let sign = CGFloat(arc4random()%2 == 1 ? 1 : -1)
        let controlPointValue = CGFloat(arc4random()%50 + arc4random()%100) * sign
        sPatch.addCurve(to: CGPoint(x: positon.x, y: positon.y - 300), controlPoint1: CGPoint.init(x: positon.x - controlPointValue, y: positon.y - 150), controlPoint2: CGPoint.init(x: positon.x + controlPointValue, y: positon.y - 150))
        positionAnimate.path = sPatch.cgPath
        imageView.layer.add(positionAnimate, forKey: "heartAnimated")
        
        UIView.animate(withDuration: TimeInterval(duration), animations: {
            imageView.layer.opacity = 0
        }) { (bool) in
            imageView.removeFromSuperview()
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
        barrageView.timer?.invalidate()
        barrageView.timer = nil
        self.barrageView.removeFromSuperview()
        print("释放")
    }
}

