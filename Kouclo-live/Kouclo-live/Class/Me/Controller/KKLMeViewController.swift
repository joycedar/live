//
//  KKLMeViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/20.
//  Copyright © 2016年 live. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
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
    
    var userInfoModel : UserProfileModel = {
        let model = UserProfileModel()
        model.name = "CedarJoy"
        model.fansCount = 12
        model.followCount = 12
        return model
    }()
    
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
