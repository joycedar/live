//
//  ShirWindMessageViewController.swift
//
//  Created by cedar on 2021/4/5.
//  Copyright © 2021 live. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum FollowSectionType: Int {
    case emptyFollowSection = 0
    case exploreSection = 1
    case roomSection = 2
    case recommemdSection = 3
    case cctvSection = 4
}

class SWFollowViewController: UIViewController {

    var userModel = UserProfileModel()
    var followViewModel = FollowViewModel()
 
    
    var tableview : UITableView = {
       let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        return tableView
    }()
    
    var refreshTool: BGRefresh = {
        let refreshTool = BGRefresh()
        refreshTool.endBlock = {
            print("结束刷新....")
        };
        refreshTool.isAutoEnd = true;
        refreshTool.refreshTime = 2.0;
        return refreshTool
    }()

    override func viewWillAppear(_ animated: Bool) {
       //self.getFollwerRoomListById(uid: String(self.userModel.uid))
//       if self.followViewModel.shouldShowEmptyViewOfNoLive {
//
//       }
        self.getAllUserListForRecommendById(uid: String(self.userModel.uid))
        return
    }
    
    override func viewDidLoad() {
        title = "关注页面"
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "global_search"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "title_button_more"), style: UIBarButtonItem.Style.done, target: nil,action: nil)
        self.view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isUserInteractionEnabled = true
        tableview.register(EmptyFollowRoomCell.self, forCellReuseIdentifier: EmptyFollowRoomCell.className())
        tableview.register(ExploreFollowCell.self, forCellReuseIdentifier: ExploreFollowCell.className())
        tableview.register(RoomCell.self, forCellReuseIdentifier: RoomCell.className())
        tableview.register(RecommemdationCell.self, forCellReuseIdentifier: RecommemdationCell.className())
        tableview.register(CCTVRoomCell.self, forCellReuseIdentifier: CCTVRoomCell.className())
        tableview.estimatedRowHeight = 213
        tableview.rowHeight = UITableView.automaticDimension
        
        tableview.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalToSuperview()
        }
        
        refreshTool.scrollview = self.tableview
        refreshTool.startBlock = {[weak self] in
            //self?.getFollwerRoomListById(uid: String(self?.userModel.uid ?? 0))
//            if self?.followViewModel.shouldShowEmptyViewOfNoLive ?? true {
//                self?.getAllUserListForRecommendById(uid: String(self?.userModel.uid ?? 0))
//            }
             self?.getAllUserListForRecommendById(uid: String(self?.userModel.uid ?? 0))
        }
    }
}
//请求关注内容，后者请求房间
extension SWFollowViewController {
    //返回关注者房间
    func getFollwerRoomListById(uid:String) {
        HttpTool.getWithPath(path: API_getFollwerRoomListById, params: ["uid":uid], success: { [weak self] data in
             if let jsonData = data as? [String:Any] {
                if let followerRoomList = jsonData["data"] as? [Any]{
                 var roomModelList = [SWRoomModel]()
                  for followerRoom in followerRoomList {
                      if let followerRoom = followerRoom as? [String:Any],
                          let name = followerRoom["nickName"] as? String,
                          let roomDescription =  followerRoom["roomName"] as? String,
                          let roomUrl = followerRoom["roomUrl"] as? String ,
                          let roomUid = followerRoom["uid"] as? Int{
                          let roomModel = SWRoomModel()
                            roomModel.uid = roomUid
                            roomModel.name = name
                            roomModel.roomDescription = roomDescription
                            roomModel.roomUrl = roomUrl
                        roomModelList.append(roomModel)
                        }
                    self?.followViewModel.liveRoomList = roomModelList
                    self?.tableview.reloadData()
                    }
                 }
             }
         }) { error in
             print(error)
         }
    }
    
    //返回推荐
    func getAllUserListForRecommendById(uid:String) {
        HttpTool.getWithPath(path: API_getAllUserListForRecommendByUid, params: ["uid":userModel.uid], success: { [weak self] data in
             if let jsonData = data as? [String:Any] {
                if let recommendFollowerList = jsonData["data"] as? [Any]{
                    var recommendModelList = [UserProfileModel]()
                  for recommendFollower in recommendFollowerList {
                      if let recommendFollower = recommendFollower as? [String:Any],
                          let uid = recommendFollower["uid"] as? Int,
                          let name = recommendFollower["name"] as? String,
                          let introduction =  recommendFollower["introduction"] as? String{
                          let userModel = UserProfileModel()
                          userModel.uid = uid
                          userModel.name = name
                          userModel.introduction = introduction
                        recommendModelList.append(userModel)
                        }
                     self?.followViewModel.followModelList = recommendModelList
                    self?.tableview.reloadData()
                    }
                 }
             }
         }) { error in
             print(error)
         }
    }
    
    //订阅
    func followUserById(targetUid:Int ,uid :Int , result: @escaping(Bool) -> ())  {
        HttpTool.postWithPath(path: API_followUserById, params: ["followId":targetUid,"userId":uid], success: { (_) in
            result(true)
        }) { (error) in
            result(false)
        }
    }
    
    
    
}
extension SWFollowViewController: RecommendDelegate {
    func didClickFollowButton(targetModel: UserProfileModel, result: @escaping (Bool) -> ()) {
        self.followUserById(targetUid: targetModel.uid, uid: self.userModel.uid, result: result)
    }
}

extension SWFollowViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case FollowSectionType.emptyFollowSection.rawValue:
            return followViewModel.shouldShowEmptyViewOfNoFollow || followViewModel.shouldShowEmptyViewOfNoLive ? 1 : 0
        case FollowSectionType.exploreSection.rawValue:
            return followViewModel.shouldShowEmptyViewOfNoFollow || followViewModel.shouldShowEmptyViewOfNoLive ? 1 : 0
        case FollowSectionType.roomSection.rawValue:
            return followViewModel.liveRoomList.count
        case FollowSectionType.recommemdSection.rawValue:
            return followViewModel.followModelList.count
        case FollowSectionType.cctvSection.rawValue:
            return followViewModel.SWCCTVModelList.count
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case FollowSectionType.emptyFollowSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: EmptyFollowRoomCell.className(), for: indexPath)
            if let cell = cell as? EmptyFollowRoomCell {
                cell.configWithModel(viewModel:followViewModel)
                return cell
            }
        case FollowSectionType.exploreSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: ExploreFollowCell.className(), for: indexPath)
            if let cell = cell as? ExploreFollowCell {
                return cell
            }
        case FollowSectionType.roomSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: RoomCell.className(), for: indexPath)
            if let cell = cell as? RoomCell {
                cell.configWithModel(model: followViewModel.liveRoomList[indexPath.row])
                return cell
            }
        case FollowSectionType.recommemdSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: RecommemdationCell.className(), for: indexPath)
            if let cell = cell as? RecommemdationCell {
                cell.configWithModel(userProfileModel: followViewModel.followModelList[indexPath.row])
                cell.delegate = self
                return cell
            }
        case FollowSectionType.cctvSection.rawValue:
            let cell = tableview.dequeueReusableCell(withIdentifier: CCTVRoomCell.className(), for: indexPath)
            if let cell = cell as? CCTVRoomCell {
                cell.configCCTV(SWCCTVModel: followViewModel.SWCCTVModelList[indexPath.row])
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label: UILabel = {
           let label = UILabel()
            
            label.font = UIFont(name: "Arial", size: 16)
            label.textColor = UIColor(rgb: 0xC3C3C5)
            return label
        }()
        let headerView = UIView()
        headerView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.leading.equalTo(12)
        }
        headerView.clipsToBounds = true
        switch section {
        case FollowSectionType.roomSection.rawValue:
            label.text = "正能量！必看！"
        case FollowSectionType.recommemdSection.rawValue:
            label.text = "快来找找有趣的人吧！"
            return headerView
        default:
            return UIView()
        }
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case FollowSectionType.exploreSection.rawValue:
            return 12
        case FollowSectionType.roomSection.rawValue:
            return 0.1
        case FollowSectionType.recommemdSection.rawValue:
            return followViewModel.shouldShowEmptyViewOfNoFollow || followViewModel.shouldShowEmptyViewOfNoLive ?  82:  0.1
        default:
            return 0.1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("🐟")
    }
    
    


    
}
