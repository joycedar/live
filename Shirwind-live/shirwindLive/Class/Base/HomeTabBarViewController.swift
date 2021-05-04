import UIKit
import SnapKit
import HyphenateChat
import EaseIMKit

class HomeTabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tabBar.shadowImage = UIImage()
        self.setupViewControllers()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraButton.sizeToFit()
        self.cameraButton.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y:UIScreen.main.bounds.height - 40)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (cameraButton.superview == nil) {
            self.tabBar.addSubview(cameraButton)
        }
    }

    func setupViewControllers(){
        let homeVC = HomeViewController()
        let meVC = MeViewController()

        let messageVC = SWConversationListViewController()
        let followVC = SWFollowViewController()
        self.setupChildViewControllow(homeVC, title: "首页", image: "home_light", selectImage: "home")
        self.setupChildViewControllow(followVC, title: "关注", image: "follow_light", selectImage: "follow")
        self.setupChildViewControllow(messageVC, title: "消息", image: "message_light", selectImage: "message")
        self.setupChildViewControllow(meVC, title: "个人", image: "me_light", selectImage: "me")
    }
    
    func setupChildViewControllow(_ childController:UIViewController,title:String,image:String,selectImage:String){
        childController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: selectImage)?.withRenderingMode(.alwaysOriginal)
        let navController = UINavigationController(rootViewController: childController)
        self.addChild(navController)
    }
    
    lazy var cameraButton:UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "tab_launch"), for: .normal)
        btn.addTarget(self, action: #selector(cameraButtonClick), for: .touchUpInside)
        btn.frame.size = CGSize(width: 50, height: 50)
        return btn
    }()

    @objc func cameraButtonClick(){
        self.present(KKLMyLiveViewController(), animated: true) {}
    }

}

//其实我只是想让它自己成为chatManager
extension HomeTabBarViewController:EMChatManagerDelegate {
    func messagesDidReceive(_ aMessages: [Any]!) {
        let conversaton = aMessages
        
    }
}
