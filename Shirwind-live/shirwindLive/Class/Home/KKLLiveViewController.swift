//
//  KKLLiveViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/29.
//  Copyright © 2016年 live. All rights reserved.
//  视频播放界面

import UIKit
import YYKit
class KKLLiveViewController: UIViewController {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var peopleCountL: UILabel!
    @IBOutlet weak var shareButton: UIImageView!
    
    var timer:Timer?
    ///弹幕的View
    var barrageView:KKLBarrageView?
    ///模型
    var cctvLive:SWCCTVModel?{
        didSet{
            peopleCountL.text = "🎈"
        }
    }
    
    var userLive:SWRoomModel?{
        didSet{
            peopleCountL.text = "🎈"
        }
    }
    
    var messagetextfile:UITextField = {
       let textFiled = UITextField()
        textFiled.returnKeyType = .done
        textFiled.backgroundColor = UIColor.white
        textFiled.tintColor = UIColor.black
        textFiled.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textFiled.placeholder = "   请文明发言～"
        textFiled.layer.shadowRadius = 10
        textFiled.layer.borderColor = UIColor.black.cgColor
        textFiled.layer.borderWidth = 2
        return textFiled
    }()
    var sendButton:UIButton = {
       let button = UIButton()
        button.setTitle("发送", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xC3C3C5)
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyBoardWillShow(notification:)) , name: UITextField.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UITextField.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.iconView.layer.cornerRadius = 15
        self.iconView.layer.masksToBounds = true
    
        timer = Timer.scheduledTimer(timeInterval: 1, target: YYWeakProxy(target: self), selector: #selector(loveAnimate), userInfo: nil, repeats: true)
        //添加弹幕的View
        self.barrageView = KKLBarrageView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 150))
        self.view.addSubview(self.barrageView ?? UIView())
        
        //添加底部的button
        self.view.addSubview(messagetextfile)
        var safeBottom = 44 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        messagetextfile.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-safeBottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        //发送窗口
        messagetextfile.delegate = self
        messagetextfile.rightView = sendButton
        
        //发送按钮增加事件
        self.sendButton.addTarget(self, action: #selector(sendMessageInRoom), for: .touchUpInside)
    }
    
    
    //长链接
    @objc
    func sendMessageInRoom() {
        HttpTool.postWithPath(path: "", params: ["barrange":"你好？"], success: { success in
            print(success)
        }) { (error) in
            print("发送弹幕失败")
        }
    }
    
    @objc
    func loveAnimate() {
        self.showLoveAnimate(fromView: self.shareButton, addToView: self.view)
    }
    
    ///心形动画
    func showLoveAnimate(fromView:UIView,addToView:UIView){
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        let loveFrame = fromView.convert(fromView.frame, to:addToView)
        let positon = CGPoint(x: fromView.layer.position.x, y: loveFrame.origin.y - 30)
        imageView.layer.position = positon
        let imgArray = ["heart_1","heart_2","heart_3","heart_4","heart_5","heart_1"]
        let imgIndex:Int = Int(arc4random()%6)
        print(imgArray[imgIndex])
        imageView.image = UIImage(named: imgArray[imgIndex])
        addToView.addSubview(imageView)
        
        imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: UIView.AnimationOptions.curveEaseOut, animations: {
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
        sPatch.addCurve(to: CGPoint(x: positon.x, y: positon.y - 300),
                        controlPoint1: CGPoint(x: positon.x - controlPointValue, y: positon.y - 150),
                        controlPoint2: CGPoint(x: positon.x + controlPointValue, y: positon.y - 150))
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

extension KKLLiveViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            self.messagetextfile.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc
    func keyBoardWillShow(notification:Notification) {
        if let keyboardFrame = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UITextField.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            var safeBottom = 44 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            self.messagetextfile.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview().offset( -keyboardFrame.height)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(44)
            }
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @objc
    func keyBoardWillHide(notification:Notification) {
        if let keyboardFrame = notification.userInfo?[UITextField.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification.userInfo?[UITextField.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            var safeBottom = 44 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            self.messagetextfile.snp.remakeConstraints { (make) in
                make.bottom.equalToSuperview().offset(-safeBottom)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(44)
            }
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
