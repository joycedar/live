
import UIKit

class MeViewController: UIViewController {
    //测试用
    var uid = "1"
    
    var  imageAndLabelDictonary = [
            ["name":"钱包","imageName":"icon_wallet"],
            ["name":"设置","imageName":"icon_setting"]
        ]
                                   
    var tableView : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.className())
        tableView.register(MeSettingCell.self, forCellReuseIdentifier: MeSettingCell.className())
        return tableView
    }()
    
    var userInfoModel = UserProfileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "个人"
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(UIScreen.main.bounds.height )
        }
        self.fetchUserInfoById(uid: uid)
    }

    
    func fetchUserInfoById(uid: String) {
        HttpTool.getWithPath(path: API_userProfileInfo, params: ["uid":self.uid], success: { [weak self] data in
            if let jsonData = data as? [String:Any],
                let userInfo = jsonData["data"] as? [String:Any]{
                if let name = userInfo["name"] as? String,
                 let fansCount =  userInfo["fansCount"] as? Int,
                  let followCount = userInfo["followsCount"] as? Int{
                    self?.userInfoModel.fansCount = fansCount
                    self?.userInfoModel.followsCount = followCount
                    self?.userInfoModel.name = name
                    self?.tableView.reloadData()
                }
            }
        }) { error in
            print(error)
        }
    }
    
    
}
extension MeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.className(), for: indexPath) as? ProfileCell {
                cell.configWithModel(userModel:userInfoModel)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: MeSettingCell.className(), for: indexPath) as? MeSettingCell {
                cell.configWithIconNameAndIconImageName(name: imageAndLabelDictonary[indexPath.row]["imageName"] ?? "", imageName: imageAndLabelDictonary[indexPath.row]["name"] ?? "")
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 140
        case 1:
            return 43
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
