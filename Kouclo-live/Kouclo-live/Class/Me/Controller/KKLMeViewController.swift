//
//  KKLMeViewController.swift
//  Kouclo-live
//
//  Created by liwei on 2016/12/20.
//  Copyright © 2016年 live. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    var tableView = UITableView()
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
        self.view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.className())
        self.tableView.register(MeSettingCell.self, forCellReuseIdentifier: MeSettingCell.className())
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(UIScreen.main.bounds.height )
        }
    }
    
    func fetchUserInfoById(id:Int) {
        AFHttpClient.sharedClient.get(API_HotLive, parameters: nil, progress: nil, success: { (task, responseObject) in
            let result = responseObject as! NSDictionary
            if((result["dm_error"] as? NSInteger) != 0){
                failure(responseObject)
            }else{
                let lives = LiveModel.mj_objectArray(withKeyValuesArray: result["lives"])
                if let lives = lives{
                    success(lives)
                }else{
                    failure(NSError())
                }
            }
        }) { (task, error) in
            failure(error as NSError)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MeSettingCell.className(), for: indexPath)
            return cell
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
}
